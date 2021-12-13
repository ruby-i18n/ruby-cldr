# encoding: utf-8

module Cldr
  module Format
    class Percent < Decimal
      def apply(number, options = {})
        super.gsub("¤", options[:percent_sign] || "%")
      end
    end
  end
end