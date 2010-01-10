class Cldr
  module Format
    class Numeric < Base
      attr_reader :prefix, :suffix, :integer_format, :fraction_format, :symbols

      DEFAULT_SYMBOLS = { :group => ',', :decimal => '.', :plus_sign => '+', :minus_sign => '-' }
      FORMAT_PATTERN  = /^([^0#,\.]*)([0#,\.]+)([^0#,\.]*)$/

      def initialize(format, symbols = {})
        @symbols = DEFAULT_SYMBOLS.merge(symbols)
        @prefix, @suffix, @integer_format, @fraction_format = *parse_format(format, symbols)
      end

      def apply(number, options = {})
        int, fraction = parse_number(number, options)

        result =  integer_format.apply(int, options)
        result << fraction_format.apply(fraction, options) if fraction
        prefix + result + suffix
      end

      protected

        def parse_format(format, symbols = {})
          format =~ FORMAT_PATTERN
          int, fraction = $2.split('.')
          [$1.to_s, $3.to_s, Integer.new(int, symbols), Fraction.new(fraction, symbols)]
        end

        def parse_number(number, options = {})
          precision = options[:precision] || fraction_format.precision
          number = round_to(number, precision)
          number.abs.to_s.split('.')
        end
    end
  end
end