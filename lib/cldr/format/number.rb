class Cldr
  module Format
    class Number
      attr_reader :positive, :negative

      def initialize(format, symbols = {})
        format = "#{format};-#{format}" unless format.index(';')
        @positive, @negative = format.split(';').map { |format| Numeric.new(format, symbols) }
      end

      def apply(number, options = {})
        number = Float(number)
        number.abs == number ? positive.apply(number, options) : negative.apply(number, options)
      rescue TypeError, ArgumentError
        number
      end
    end
  end
end