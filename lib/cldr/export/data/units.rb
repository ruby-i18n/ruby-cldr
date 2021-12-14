# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class Units < Base
        def initialize(locale)
          super
          update(
            units: {
              unitLength: unitLength,
              durationUnit: durationUnit,
            }
          )
        end

        def unitLength
          select("units/unitLength").each_with_object({}) do |node, result|
            result[node.attribute("type").value.to_sym] = units(node)
          end
        end

        def units(node)
          node.xpath("unit").each_with_object({}) do |node, result|
            result[node.attribute("type").value.to_sym] = unit(node)
          end
        end

        def unit(node)
          node.xpath("unitPattern").each_with_object({}) do |node, result|
            count = node.attribute("count") ? node.attribute("count").value.to_sym : :one
            result[count] = node.content unless draft?(node)
          end
        end

        def durationUnit
          select("units/durationUnit").each_with_object({}) do |node, result|
            result[node.attribute("type").value.to_sym] = node.xpath("durationUnitPattern").first.content
          end
        end
      end
    end
  end
end
