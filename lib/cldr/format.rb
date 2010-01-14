# encoding: utf-8
require 'core_ext/string/camelize'

class Cldr
  module Format
    autoload :Base,     'cldr/format/base'
    autoload :Currency, 'cldr/format/currency'
    autoload :Fraction, 'cldr/format/fraction'
    autoload :Integer,  'cldr/format/integer'
    autoload :Date,     'cldr/format/date'
    autoload :Datetime, 'cldr/format/datetime'
    autoload :Decimal,  'cldr/format/decimal'
    autoload :Numeric,  'cldr/format/numeric'
    autoload :Percent,  'cldr/format/percent'
    autoload :Time,     'cldr/format/time'

    def format(locale, number, options = {})
      type = options.has_key?(:currency) ? :currency : options.delete(:as)
      type || raise_unspecified_format_type!

      send(:"format_#{type}", locale, number, options)
    end

    def format_decimal(locale, number, options = {})
      formatter(locale, :decimal, options.delete(:format)).apply(number, options)
    end
    alias :format_number :format_decimal

    def format_integer(locale, number, options = {})
      format_number(number, options.merge(:precision => 0))
    end
    alias :format_int :format_integer

    def format_currency(locale, number, options = {})
      if options[:currency].is_a?(Symbol)
        options.merge!(:currency => lookup_currency(locale, options[:currency], number))
      end
      formatter(locale, :currency, options.delete(:format)).apply(number, options)
    end

    def format_percent(locale, number, options = {})
      formatter(locale, :percent, options.delete(:format)).apply(number, options)
    end

    def format_date(locale, date, options = {})
      formatter(locale, :date, options.delete(:format)).apply(date, options)
    end

    def format_time(locale, time, options = {})
      formatter(locale, :time, options.delete(:format)).apply(time, options)
    end

    def format_datetime(locale, datetime, options = {})
      format = options.delete(:format)
      (@formatters ||= {})[:"#{locale}.datetime.#{format}"] ||= begin
        date = formatter(locale, :date, options.delete(:date_format) || format)
        time = formatter(locale, :time, options.delete(:time_format) || format)
        format = lookup_format(locale, :datetime, format)
        Cldr::Format::Datetime.new(format, date, time).apply(datetime, options)
      end
    end

    protected

      def formatter(locale, type, format)
        (@formatters ||= {})[:"#{locale}.#{type}.#{format}"] ||= begin
          format = lookup_format(locale, type, format)
          data   = lookup_format_data(locale, type)
          Cldr::Format.const_get(type.to_s.camelize).new(format, data)
        end
      end

      def raise_unspecified_format_type!
        raise ArgumentError.new("You have to specify a format type, e.g. :as => :number.")
      end

      def raise_unspecified_currency!
        raise ArgumentError.new("You have to specify a currency, e.g. :currency => 'EUR'.")
      end
  end
end