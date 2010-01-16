class Cldr
  module Format
    class Decimal
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
      end
    end
  end
end