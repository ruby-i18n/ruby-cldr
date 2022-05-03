# frozen_string_literal: true

require "nokogiri"

module Cldr
  module Export
    module Data
      class CurrencyDigitsAndRounding < Hash
        def initialize
          super

          Cldr::Export::Data::RAW_DATA[nil].xpath("//currencyData/fractions/info").each do |node|
            code = node.attr("iso4217")
            digits = node.attr("digits").to_i
            rounding = node.attr("rounding").to_i

            self[code.upcase.to_sym] = { digits: digits, rounding: rounding }
          end
        end
      end
    end
  end
end
