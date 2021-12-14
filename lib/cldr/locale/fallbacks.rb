# frozen_string_literal: true

module Cldr
  module Locale
    class Fallbacks < Hash
      def [](locale)
        defined_parents = Cldr::Export::Data::ParentLocales.new

        ancestry = [locale]
        loop do
          if defined_parents[ancestry.last]
            ancestry << defined_parents[ancestry.last]
          elsif I18n::Locale::Tag.tag(ancestry.last).parents.count > 0
            ancestry << I18n::Locale::Tag.tag(ancestry.last).parents.first.to_sym
          else
            break
          end
        end
        ancestry << :root unless ancestry.last == :root
        store(locale, ancestry)
      end
    end
  end
end
