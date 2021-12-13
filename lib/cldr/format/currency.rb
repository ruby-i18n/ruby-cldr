# encoding: utf-8

module Cldr
  module Format
    class Currency < Decimal
      def apply(number, options = {})
        super.gsub("¤", options[:currency] || "$")
      end
    end
  end
end