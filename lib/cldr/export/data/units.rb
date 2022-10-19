# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class Units < Base
        def initialize(locale)
          super
          update(
            units: {
              duration_unit: duration_unit,
              unit_length: unit_length,
            },
          )
          deep_sort!
        end

        private

        def unit_length
          select("units/unitLength").each_with_object({}) do |node, result|
            result[node.attribute("type").value.underscore.to_sym] = units(node)
          end
        end

        def units(node)
          aliased = select_single(node, "alias")
          return units_xpath_to_key(aliased.attribute("path").value) if aliased

          node.xpath("unit").each_with_object({}) do |node, result|
            result[node.attribute("type").value.underscore.to_sym] = unit(node)
          end
        end

        def unit(node)
          aliased = select_single(node, "alias")
          return unit_xpath_to_key(aliased.attribute("path").value) if aliased

          node.xpath("unitPattern").each_with_object({}) do |node, result|
            # Ignore cases for now. We don't have a way to expose them yet.
            # TODO: https://github.com/ruby-i18n/ruby-cldr/issues/67
            next result if node.attribute("case")

            count = node.attribute("count") ? node.attribute("count").value.to_sym : :one
            result[count] = node.content
          end
        end

        def duration_unit
          select("units/durationUnit").each_with_object({}) do |node, result|
            result[node.attribute("type").value.underscore.to_sym] = node.xpath("durationUnitPattern").first.content
          end
        end

        def units_xpath_to_key(xpath)
          match = xpath.match(%r{^\.\./unitLength\[@type='([^']*)'\]$})
          raise StandardError, "Didn't find expected data in alias path attribute: #{xpath}" unless match

          type = match[1].underscore
          :"units.unit_length.#{type}"
        end

        def unit_xpath_to_key(xpath)
          match = xpath.match(%r{^\.\./unit\[@type='([^']*)'\]$})
          raise StandardError, "Didn't find expected data in alias path attribute: #{xpath}" unless match

          type = match[1].underscore
          :"units.unit_length.short.#{type}"
        end
      end
    end
  end
end
