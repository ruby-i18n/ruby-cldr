# frozen_string_literal: true

module Cldr
  module Format
    class Decimal
      class Fraction < Base
        attr_reader :decimal, :precision

        def initialize(format, symbols = {})
          super()

          @format  = format ? format.split(".").pop : ""
          @decimal = symbols[:decimal] || "."
          @precision = @format.length
        end

        def apply(fraction, options = {})
          precision = options[:precision] || self.precision
          if precision > 0
            decimal + interpolate(format(options), fraction, :left)
          else
            ""
          end
        end

        def format(options)
          options[:precision] ? "0" * options[:precision] : @format
        end
      end
    end
  end
end
