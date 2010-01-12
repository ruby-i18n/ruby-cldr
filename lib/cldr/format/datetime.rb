class Cldr
  module Format
    class Datetime
      PATTERN = /G{1,5}|y+|Y+|Q{1,4}|q{1,5}|M{1,5}|L{1,5}|d{1,2}|F{1}|E{1,5}|
                 e{1,5}|c{1,5}|m{1,2}|a{1}|h{1,2}|H{1,2}|K{1,2}|k{1,2}|s{1,2}|
                 S+|z{1,4}|Z{1,4}/x
      METHODS = { # ignoring u, l, g, j, A
        'G' => :era,
        'y' => :year,
        'Y' => :year_of_week_of_year,
        'Q' => :quarter,
        'q' => :quarter_stand_alone,
        'M' => :month,
        'L' => :month_stand_alone,
        'w' => :week_of_year,
        'W' => :week_of_month,
        'd' => :day,
        'D' => :day_of_month,
        'F' => :day_of_week_in_month,
        'E' => :weekday,
        'e' => :weekday_local,
        'c' => :weekday_local_stand_alone,
        'a' => :period,
        'h' => :hour,
        'H' => :hour,
        'K' => :hour,
        'k' => :hour,
        'm' => :minute,
        's' => :second,
        'S' => :second_fraction,
        'z' => :timezone,
        'Z' => :timezone,
        'v' => :timezone_generic_non_location,
        'V' => :timezone_metazone,
      }
      attr_reader :calendar

      def initialize(format, calendar)
        @calendar = calendar
        compile_format(format)
      end

      def compile_format(format)
        (class << self; self; end).class_eval <<-code
          def apply(date, options = {})
            '#{format.gsub(PATTERN) { |token| compile_call(token) }}'
          end
        code
      end

      def compile_call(token)
        "' + " + METHODS[token[0]] + "(date, #{token.inspect}, #{token.length}) + '"
      end

      def era(date, pattern, length)
        raise 'not implemented'
      end

      def year(date, pattern, length)
        year = date.year.to_s
        year = year.length == 1 ? year : year[-2, 2] if length == 2
        year = year.rjust(length, '0') if length > 1
        year
      end

      def year_of_week_of_year(date, pattern, length)
        raise 'not implemented'
      end

      def day_of_week_in_month(date, pattern, length) # e.g. 2nd Wed in July
        raise 'not implemented'
      end

      def quarter(date, pattern, length)
        quarter = (date.month.to_i - 1) / 3 + 1
        case length
        when 1
          quarter.to_s
        when 2
          quarter.to_s.rjust(length, '0')
        when 3
          calendar[:quarters][:format][:abbreviated][quarter]
        when 4
          calendar[:quarters][:format][:wide][quarter]
        end
      end

      def quarter_stand_alone(date, pattern, length)
        quarter = (date.month.to_i - 1) / 3 + 1
        case length
        when 1
          quarter.to_s
        when 2
          quarter.to_s.rjust(length, '0')
        when 3
          raise 'not yet implemented (requires cldr\'s "multiple inheritance")'
          # calendar[:quarters][:'stand-alone'][:abbreviated][key]
        when 4
          raise 'not yet implemented (requires cldr\'s "multiple inheritance")'
          # calendar[:quarters][:'stand-alone'][:wide][key]
        when 5
          calendar[:quarters][:'stand-alone'][:narrow][quarter]
        end
      end

      def month(date, pattern, length)
        case length
        when 1
          date.month.to_s
        when 2
          date.month.to_s.rjust(length, '0')
        when 3
          calendar[:months][:format][:abbreviated][date.month]
        when 4
          calendar[:months][:format][:wide][date.month]
        when 5
          raise 'not yet implemented (requires cldr\'s "multiple inheritance")'
          calendar[:months][:format][:narrow][date.month]
        else
          # raise unknown date format
        end
      end

      def month_stand_alone(date, pattern, length)
        case length
        when 1
          date.month.to_s
        when 2
          date.month.to_s.rjust(length, '0')
        when 3
          raise 'not yet implemented (requires cldr\'s "multiple inheritance")'
          calendar[:months][:'stand-alone'][:abbreviated][date.month]
        when 4
          raise 'not yet implemented (requires cldr\'s "multiple inheritance")'
          calendar[:months][:'stand-alone'][:wide][date.month]
        when 5
          calendar[:months][:'stand-alone'][:narrow][date.month]
        else
          # raise unknown date format
        end
      end

      def day(date, pattern, length)
        case length
        when 1
          date.day.to_s
        when 2
          date.day.to_s.rjust(length, '0')
        end
      end

      WEEKDAY_KEYS = [:sun, :mon, :tue, :wed, :thu, :fri, :sat]

      def weekday(date, pattern, length)
        key = WEEKDAY_KEYS[date.wday]
        case length
        when 1..3
          calendar[:days][:format][:abbreviated][key]
        when 4
          calendar[:days][:format][:wide][key]
        when 5
          calendar[:days][:'stand-alone'][:narrow][key]
        end
      end

      def weekday_local(date, pattern, length)
        # "Like E except adds a numeric value depending on the local starting day of the week"
        raise 'not implemented (need to defer a country to lookup the local first day of week from weekdata)'
      end

      def weekday_local_stand_alone(date, pattern, length)
        raise 'not implemented (need to defer a country to lookup the local first day of week from weekdata)'
      end

      def period(time, pattern, length)
        calendar[:periods][time.strftime('%p').downcase.to_sym]
      end

      def hour(time, pattern, length)
        hour = time.hour
        hour = case pattern[0]
        when 'h' # [1-12]
          hour > 12 ? (hour - 12) : (hour == 0 ? 12 : hour)
        when 'H' # [0-23]
          hour
        when 'K' # [0-11]
          hour > 11 ? hour - 12 : hour
        when 'k' # [1-24]
          hour == 0 ? 24 : hour
        end
        length == 1 ? hour.to_s : hour.to_s.rjust(length, '0')
      end

      def minute(time, pattern, length)
        length == 1 ? time.min.to_s : time.min.to_s.rjust(length, '0')
      end

      def second(time, pattern, length)
        length == 1 ? time.sec.to_s : time.sec.to_s.rjust(length, '0')
      end

      def second_fraction(time, pattern, length)
        raise 'can not use the S format with more than 6 digits' if length > 6
        (time.usec.to_f / 10 ** (6 - length)).round.to_s.rjust(length, '0')
      end

      def timezone(time, pattern, length)
        case length
        when 1..3
          time.zone
        else
          raise 'not yet implemented (requires timezone translation data")'
        end
      end

      def timezone_generic_non_location(time, pattern, length)
        raise 'not yet implemented (requires timezone translation data")'
      end

      def round_to(number, precision)
        factor = 10 ** precision
        (number * factor).round.to_f / factor
      end
    end
  end
end