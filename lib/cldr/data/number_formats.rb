module Cldr
  module Data
    class NumberFormats < Base
      def data
        map = {
          'numbers/decimalFormats/decimalFormatLength/decimalFormat/*'          => 'numbers/formats/decimal',
          'numbers/scientificFormats/scientificFormatLength/scientificFormat/*' => 'numbers/formats/scientific',
          'numbers/percentFormats/percentFormatLength/percentFormat/*'          => 'numbers/formats/percent',
          'numbers/currencyFormats/currencyFormatLength/currencyFormat/*'       => 'numbers/formats/currency',
          'numbers/currencyFormats/unitPattern'                                 => 'numbers/formats/currency/unit'
        }
        extract(map)
      end
    end
  end
end