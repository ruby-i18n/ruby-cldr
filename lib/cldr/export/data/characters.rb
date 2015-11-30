module Cldr
  module Export
    module Data
      class Characters < Base
        def initialize(locale)
          super
          update(:characters => { :exemplars => exemplars })
        end

        def exemplars
          select('/ldml/characters/exemplarCharacters').map do |node|
            {
              # remove enclosing brackets
              characters: node.content[1..-2],
              type: type_from(node)
            }
          end
        end

        protected

        def type_from(node)
          if attrib = node.attribute('type')
            attrib.value
          end
        end
      end
    end
  end
end
