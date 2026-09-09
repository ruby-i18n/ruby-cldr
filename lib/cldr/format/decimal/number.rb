# frozen_string_literal: true

require "bigdecimal"

module Cldr
  module Format
    class Decimal
      class Number
        attr_reader :prefix, :suffix, :integer_format, :fraction_format, :symbols

        DEFAULT_SYMBOLS = { group: ",", decimal: ".", plus_sign: "+", minus_sign: "-" }.freeze
        FORMAT_PATTERN  = /([^0#,\.]*)([0#,\.]+)([^0#,\.]*)$/

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
          prefix, suffix, int, fraction = Regexp.last_match(1).to_s, Regexp.last_match(3).to_s, *Regexp.last_match(2).split(".")
          [prefix, suffix, Integer.new(int, symbols), Fraction.new(fraction, symbols)]
        end

        def parse_number(number, options = {})
          precision = options[:precision] || fraction_format.precision
          number = round_to(number, precision)
          number.abs.to_s("F").split(".")
        end

        # BigDecimal keeps full precision, avoids Float scientific notation, and
        # rounds half-even (ties to even) as CLDR / UTS #35 mandates.
        def round_to(number, precision)
          BigDecimal(number.to_r, 0).round(precision, half: :even)
        end
      end
    end
  end
end
