# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class Lists < Base
        def initialize(locale)
          super
          update(lists: lists)
        end

        def lists
          select("listPatterns/listPattern").each_with_object({}) do |list_pattern, list_pattern_ret|
            pattern_type = if attribute = list_pattern.attribute("type")
              attribute.value.to_sym
            else
              :default
            end

            list_pattern_ret[pattern_type] = select(list_pattern, "listPatternPart").each_with_object({}) do |part, part_ret|
              part_ret[part.attribute("type").value.to_sym] = part.content
            end
          end
        end
      end
    end
  end
end
