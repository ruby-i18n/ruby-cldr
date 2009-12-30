module Cldr
  module Data
    class Delimiters < Base
      def data
        map = {
          'delimiters/quotationStart'          => 'delimiters/quotes/default/start',
          'delimiters/quotationEnd'            => 'delimiters/quotes/default/end',
          'delimiters/alternateQuotationStart' => 'delimiters/quotes/alternate/start',
          'delimiters/alternateQuotationEnd'   => 'delimiters/quotes/alternate/end'
        }
        extract(map)
      end
    end
  end
end
