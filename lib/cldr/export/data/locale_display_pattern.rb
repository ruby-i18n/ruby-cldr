# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class LocaleDisplayPattern < Base
        def initialize(locale)
          super
          update(locale_display_pattern: locale_display_pattern)
        end

        private

        def locale_display_pattern
          @locale_display_pattern ||= select("localeDisplayNames/localeDisplayPattern/*").each_with_object({}) do |node, result|
            result[node.name.underscore] = node.content
          end
        end
      end
    end
  end
end
