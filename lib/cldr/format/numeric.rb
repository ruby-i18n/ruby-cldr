class Cldr
  module Format
    class Numeric < Base
      attr_reader :formats, :symbols, :precision

      def initialize(format, symbols = {})
        @symbols   = { :group => ',', :decimal => '.', :plus_sign => '+', :minus_sign => '-' }.merge(symbols)
        @formats   = parse_format(format, symbols)
        @precision = formats[:fraction] ? formats[:fraction].precision : 0
      end

      def apply(number, options = {})
        int, fraction = parse_number(number, options)

        result =  formats[:integer].apply(int, options)
        result << formats[:fraction].apply(fraction, options) if formats[:fraction] && fraction
        formats[:prefix] + result + formats[:suffix]
      end

      protected

        def parse_format(format, symbols = {})
          format =~ /^([^0#,\.]*)([0#,\.]+)([^0#,\.]*)$/
          int, fraction = $2.split('.')
          { 
            :prefix   => $1.to_s,
            :suffix   => $3.to_s,
            :integer  => Integer.new(int, symbols),
            :fraction => Fraction.new(fraction, symbols)
          }
        end
        
        def parse_number(number, options = {})
          precision = options[:precision] || self.precision
          number = round_to(number, precision)
          number.abs.to_s.split('.')
        end
    end
  end
end