# encoding: utf-8
# frozen_string_literal: true

module Cldr
  module Format
    class Currency < Decimal
      def apply(number, options = {})
        super.gsub("¤", options[:currency] || "$")
      end
    end
  end
end