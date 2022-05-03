# frozen_string_literal: true

require "nokogiri"

module Cldr
  module Export
    module Data
      class ParentLocales < Hash
        def initialize
          super

          Cldr::Export::Data::RAW_DATA[nil].xpath("//parentLocales/parentLocale").each do |node|
            parent = Cldr::Export.to_i18n(node.attr("parent"))
            locales = node.attr("locales").split(" ").map { |locale| Cldr::Export.to_i18n(locale) }

            locales.each do |locale|
              self[locale] = parent
            end
          end
        end

        def to_h
          deep_stringify
        end
      end
    end
  end
end
