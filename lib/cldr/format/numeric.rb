class Cldr
  module Format
    class Numeric
      attr_reader :int, :fraction, :prefix, :suffix, :locale

      def initialize(format, locale = {})
        @locale = { :group => ',', :decimal => '.' }.merge(locale)
        @prefix, @suffix, @int, @fraction = parse_format(format)
      end

      def apply(number)
        int, fraction = parse_number(number)
        result = interpolate(self.int.gsub(',', ''), int)
        result = apply_group(result)
        result = apply_fraction(result, fraction)
        prefix + result + suffix
      end

      def group?
        @group ||= !!int.rindex(',')
      end

      def groups
        @groups ||= begin
          index  = int.rindex(',')
          rest   = int[0, index]
          widths = [int.length - index - 1]
          widths << rest.length - rest.rindex(',') - 1 if rest.rindex(',')
          widths.compact.uniq
        end
      end

      protected
      
        def parse_format(format)
          format =~ /^([^0#,\.]*)([0#,\.]+)([^0#,\.]*)$/
          [$1.to_s, $3.to_s] + $2.split('.')
        end

        def parse_number(number)
          number = round_to(number, fraction.length) if fraction
          number.to_f.abs.to_s.split('.')
        end

        def interpolate(string, value, orientation = :right)
          length = value.length
          start, pad = orientation == :left ? [0, :rjust] : [-length, :ljust]
          string = string.send(pad, length, '#') if string.length < length
          string[start, length] = value
          string.gsub('#', '')
        end

        def apply_group(string)
          return string unless group?
          tokens = []
          tokens << chop_group(string, groups.first)
          tokens << chop_group(string, groups.last) while string.length > groups.last
          tokens << string
          tokens.compact.reverse.join(locale[:group])
        end

        def chop_group(string, size)
          string.slice!(-size, size) if string.length > size
        end

        def apply_fraction(string, fraction)
          return string unless self.fraction && fraction
          string << locale[:decimal] + interpolate(self.fraction, fraction, :left)
        end

        def round_to(number, precision)
          factor = 10 ** precision
          (number * factor).round.to_f / factor
        end
    end
  end
end