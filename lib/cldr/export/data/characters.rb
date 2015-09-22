module Cldr
  module Export
    module Data
      class Characters < Base
        def initialize(locale)
          super
          update(:exemplars => exemplars)
        end

        def exemplars
          select('characters/exemplarCharacters').map do |node|
            {
              # remove enclosing brackets
              characters: node.content[1..-2],
              type: node.attribute('type').value
            }
          end
        end
      end
    end
  end
end
