class Cldr
  module Format
    class Base
      def interpolate(string, value, orientation = :right)
        string = string.dup
        value  = value.to_s
        length = value.length
        start, pad = orientation == :left ? [0, :rjust] : [-length, :ljust]

        string = string.send(pad, length, '#') if string.length < length
        string[start, length] = value
        string.gsub('#', '')
      end

      def round_to(number, precision)
        factor = 10 ** precision
        (number * factor).round.to_f / factor
      end
    end
  end
end