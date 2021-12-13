module Cldr
  module Export
    module Data
      class Languages < Base
        def initialize(locale)
          super
          update(:languages => languages)
        end

        def languages
          @languages ||= select("localeDisplayNames/languages/language").inject({}) do |result, node|
            result[Cldr::Export.to_i18n(node.attribute("type").value)] = node.content unless draft?(node) or alt?(node)
            result
          end
        end
      end
    end
  end
end
