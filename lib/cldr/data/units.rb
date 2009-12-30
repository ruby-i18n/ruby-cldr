module Cldr
  module Data
    class Units < Base
      def data
        { :units => units }
      end

      def units
        select('units/unit').inject({}) do |result, node|
          result[node.attribute('type').value.to_sym] = unit(node)
          result
        end
      end

      def unit(node)
        node.xpath('unitPattern').inject({}) do |result, node|
          count = node.attribute('count') ? node.attribute('count').value.to_sym : :one
          result[count] = node.content unless draft?(node)
          result
        end
      end
    end
  end
end
