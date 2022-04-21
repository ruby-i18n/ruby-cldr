# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class Languages < Base
        def initialize(locale)
          super
          update(languages: languages)
        end

        private

        def languages
          @languages ||= select("localeDisplayNames/languages/language").each_with_object({}) do |node, result|
            result[Cldr::Export.to_i18n(node.attribute("type").value)] = node.content
          end
        end
      end
    end
  end
end
