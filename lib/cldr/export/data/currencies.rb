module Cldr
  module Export
    module Data
      class Currencies < Base
        def initialize(locale)
          super
          update(:currencies => currencies)
        end

        def currencies
          select('numbers/currencies/*').inject({}) do |result, node|
            currency = self.currency(node)
            result[node.attribute('type').value.to_sym] = currency unless currency.empty?
            result
          end
        end

        def currency(node)
          data = select(node, 'displayName').inject({}) do |result, node|
            count = node.attribute('count') ? node.attribute('count').value.to_sym : :one
            result[count] = node.content unless draft?(node)
            result
          end

          symbol = select(node, 'symbol')
          data[:symbol] = symbol.first.content if symbol.length > 0

          data
        end
      end
    end
  end
end