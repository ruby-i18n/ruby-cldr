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
            unless draft?(node)
              if node.attribute('count')
                count = node.attribute('count').value.to_sym
                result[count] = node.content
              else
                result[:one] = node.content if result[:one].nil?
                result[:name] = node.content
              end
            end

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
