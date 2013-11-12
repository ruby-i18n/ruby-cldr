module Cldr
  module Export
    module Data
      class Units < Base
        def initialize(locale)
          super
          update(
            :units => {
              :unitLength => unitLength,
              :durationUnit => durationUnit,
            }
          )
        end

        def unitLength
          select('units/unitLength').inject({}) do |result, node|
            result[node.attribute('type').value.to_sym] = units(node)
            result
          end
        end

        def units(node)
          node.xpath('unit').inject({}) do |result, node|
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

        def durationUnit
          select('units/durationUnit').inject({}) do |result, node|
            result[node.attribute('type').value.to_sym] = node.xpath('durationUnitPattern').first.content
            result
          end
        end
      end
    end
  end
end