module Cldr
  module Data
    class Currencies < Base
      def data
        { :currencies => currencies }
      end

      def currencies
        select('numbers/currencies/*').inject({}) do |result, node|
          result[node.attribute('type').value.to_sym] = currency(node)
          result
        end
      end

      def currency(node)
        node.xpath('displayName').inject({}) do |result, node|
          count = node.attribute('count') ? node.attribute('count').value.to_sym : :one
          result[count] = node.content unless draft?(node)
          result
        end
      end
    end
  end
end
