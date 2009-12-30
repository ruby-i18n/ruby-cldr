module Cldr
  module Data
    class NumberSymbols < Base
      def data
        { :numbers => { :symbols => symbols } }
      end

      def symbols
        select('numbers/symbols/*').inject({}) do |result, node|
          result[name(node).to_sym] = node.content unless draft?(node)
          result
        end
      end
    end
  end
end