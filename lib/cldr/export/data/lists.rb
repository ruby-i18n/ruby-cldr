# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class Lists < Base
        def initialize(locale)
          super
          update(lists: lists)
        end

        private

        def lists
          select("listPatterns/listPattern").each_with_object({}) do |list_pattern, list_pattern_ret|
            pattern_type = if (attribute = list_pattern.attribute("type"))
              attribute.value.to_sym
            else
              :default
            end
            list_pattern_ret[pattern_type] = list_pattern(list_pattern)
          end
        end

        def list_pattern(list_pattern)
          aliased = select(list_pattern, "alias").first
          if aliased
            xpath_to_key(aliased.attribute("path").value)
          else
            get_pattern_parts(list_pattern)
          end
        end

        def get_pattern_parts(list_pattern)
          select(list_pattern, "listPatternPart").each_with_object({}) do |part, part_ret|
            part_ret[part.attribute("type").value.to_sym] = part.content
          end
        end

        def xpath_to_key(xpath)
          return :"lists.default" if xpath == "../listPattern"

          match = xpath.match(%r{^\.\./listPattern\[@type='([^']*)'\]$})
          raise StandardError, "Didn't find expected data in alias path attribute: #{xpath}" unless match

          type = match[1]
          :"lists.#{type}"
        end
      end
    end
  end
end
