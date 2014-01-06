require 'pry-nav'

module Cldr
  module Export
    module Data
      class Lists < Base
        def initialize(locale)
          super
          update(:lists => lists)
        end

        def lists
          select('listPatterns/listPattern').inject({}) do |list_pattern_ret, list_pattern|
            pattern_type = if attribute = list_pattern.attribute('type')
              attribute.value.to_sym
            else
              :default
            end

            list_pattern_ret[pattern_type] = select(list_pattern, 'listPatternPart').inject({}) do |part_ret, part|
              part_ret[part.attribute('type').value.to_sym] = part.content
              part_ret
            end
            list_pattern_ret
          end
        end
      end
    end
  end
end