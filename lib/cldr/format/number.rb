class Cldr
  module Format
    class Number
      attr_reader :positive, :negative

      def initialize(format, symbols = {})
        list  = symbols[:list]  || ';'
        minus = symbols[:minus] || '-'
        format = "#{format}#{list}#{minus}#{format}" unless format.index(list)
        @positive, @negative = format.split(list).map { |format| Numeric.new(format, symbols) }
      end

      def apply(number, options = {})
        number = Float(number)
        format = number.abs == number ? positive : negative
        format.apply(number, options)
      rescue TypeError, ArgumentError
        number
      end
    end
  end
end