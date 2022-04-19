# frozen_string_literal: true

require "nokogiri"

module Cldr
  module Export
    module Data
      class CurrencyDigitsAndRounding < Hash
        def initialize
          super

          path = "#{Cldr::Export::Data.dir}/supplemental/supplementalData.xml"
          doc = Cldr::Export::DataFile.parse(File.read(path))

          doc.xpath("//currencyData/fractions/info").each do |node|
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
