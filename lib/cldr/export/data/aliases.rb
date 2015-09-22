module Cldr
  module Export
    module Data
      class Aliases < Base

        # only these aliases will be exported
        ALIAS_TAGS = %w(languageAlias territoryAlias)

        def initialize
          super(nil)
          update(:aliases => aliases)
        end

        private

        def aliases
          ALIAS_TAGS.inject({}) do |ret, alias_tag|
            ret[alias_tag.sub('Alias', '')] = alias_for(alias_tag)
            ret
          end
        end

        def alias_for(alias_tag)
          doc.xpath("//alias/#{alias_tag}").inject({}) do |ret, alias_data|
            if replacement_attr = alias_data.attribute('replacement')
              replacement = replacement_attr.value

              if replacement.include?(' ')
                replacement = replacement.split(' ')
              end

              type = alias_data.attribute('type').value
              ret[type] = replacement
            end

            ret
          end
        end

        def path
          @path ||= "#{Cldr::Export::Data.dir}/supplemental/supplementalMetadata.xml"
        end

      end
    end
  end
end
