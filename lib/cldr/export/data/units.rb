# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class Units < Base
        def initialize(locale)
          super
          update(
            units: {
              unitLength: unit_length,
              durationUnit: duration_unit,
            }
          )
        end

        private

        def unit_length
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
            next result if node.attribute("case") # Ignore cases for now. We don't have a way to expose them yet.
            count = node.attribute("count") ? node.attribute("count").value.to_sym : :one
            result[count] = node.content
          end
        end

        def duration_unit
          select("units/durationUnit").each_with_object({}) do |node, result|
            result[node.attribute("type").value.to_sym] = node.xpath("durationUnitPattern").first.content
          end
        end
      end
    end
  end
end
