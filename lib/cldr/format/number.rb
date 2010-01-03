class Cldr
  module Format
    class Number
      attr_reader :positive, :negative

      def initialize(format, locale = {})
        format  = "#{format};-#{format}" unless format.index(';')
        @positive, @negative = format.split(';').map { |format| Numeric.new(format, locale) }
      end
      
      def apply(number)
        number.abs == number ? positive.apply(number) : negative.apply(number)
      end
    end
  end
end