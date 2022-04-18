# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class Characters < Base
        def initialize(locale)
          super
          update(characters: { exemplars: exemplars })
        end

        private

        def exemplars
          select("/ldml/characters/exemplarCharacters").map do |node|
            {
              # remove enclosing brackets
              characters: node.content[1..-2],
              type: type_from(node),
            }
          end
        end

        protected

        def type_from(node)
          node.attribute("type")&.value
        end
      end
    end
  end
end
