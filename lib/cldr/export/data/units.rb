module Cldr
  module Export
    module Data
      class Units < Base
        def initialize(locale)
          super
          update(:units => units)
        end

        def units
          select('units/unit').inject({}) do |result, node|
            result[node.attribute('type').value.to_sym] = unit(node)
            result
          end
        end

        def unit(node)
          node.xpath('unitPattern').inject({}) do |result, node|
            alt = node.attribute('alt') ? node.attribute('alt').value.to_sym : :default
            count = node.attribute('count') ? node.attribute('count').value.to_sym : :one
            result[alt] ||= {}
            result[alt][count] = node.content unless draft?(node)
            result
          end
        end
      end
    end
  end
end