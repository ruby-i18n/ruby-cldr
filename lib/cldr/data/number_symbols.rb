module Cldr
  module Data
    class NumberSymbols < Base
      def data
        extract('numbers/symbols/*' => 'numbers/symbols')
      end
    end
  end
end