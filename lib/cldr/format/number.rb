class Cldr
  module Format
    class Number
      attr_reader :positive, :negative

      def initialize(format, symbols = {})
        format = "#{format};-#{format}" unless format.index(';')
        @positive, @negative = format.split(';').map { |format| Numeric.new(format, symbols) }
      end

      def apply(number, options = {})
        return number unless number.respond_to?(:abs)
        number.abs == number ? positive.apply(number, options) : negative.apply(number, options)
      end
    end
  end
end