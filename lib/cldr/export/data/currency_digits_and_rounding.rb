# frozen_string_literal: true

require "nokogiri"

module Cldr
  module Export
    module Data
      class CurrencyDigitsAndRounding < Hash
        def initialize
          path = "#{Cldr::Export::Data.dir}/supplemental/supplementalData.xml"
          doc = File.open(path) { |file| Nokogiri::XML(file) }

          currency_digits_and_rounding = doc.xpath("//currencyData/fractions/info").each do |node|
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
