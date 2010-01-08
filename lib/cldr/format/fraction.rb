class Cldr
  module Format
    class Fraction < Base
      attr_reader :format, :decimal, :precision

      def initialize(format, symbols = {})
        @format  = format.split('.').pop
        @decimal = symbols[:decimal] || '.'
        @precision = format.length
      end

      def apply(fraction, options = {})
        return '' if options[:precision] == 0
        decimal + interpolate(format(options), fraction, :left)
      end

      def format(options)
        options[:precision] ? '0' * options[:precision] : @format
      end
    end
  end
end