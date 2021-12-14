# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class Aliases < Base
        # only these aliases will be exported
        ALIAS_TAGS = ["languageAlias", "territoryAlias"]

        def initialize
          super(nil)
          update(aliases: aliases)
        end

        private

        def aliases
          ALIAS_TAGS.each_with_object({}) do |alias_tag, ret|
            ret[alias_tag.sub("Alias", "")] = alias_for(alias_tag)
          end
        end

        def alias_for(alias_tag)
          doc.xpath("//alias/#{alias_tag}").each_with_object({}) do |alias_data, ret|
            next unless (replacement_attr = alias_data.attribute("replacement"))
            replacement = replacement_attr.value

            if replacement.include?(" ")
              replacement = replacement.split(" ")
            end

            type = alias_data.attribute("type").value
            ret[type] = replacement
          end
        end
      end
    end
  end
end
