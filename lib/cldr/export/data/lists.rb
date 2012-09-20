module Cldr
  module Export
    module Data
      class Lists < Base
        def initialize(locale)
          super
          update(:lists => lists)
        end

        def lists
          select('listPatterns/listPattern/listPatternPart').inject({}) do |result, node|
            result[node.attribute('type').value.to_sym] = node.content
            result
          end
        end
      end
    end
  end
end