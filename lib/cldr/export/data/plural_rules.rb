require 'nokogiri'
require 'pry-nav'

module Cldr
  module Export
    module Data
      class PluralRules < Hash
        attr_reader :locale

        def initialize(locale)
          find_rules(locale).each do |rule|
            self[rule.attributes['count'].text] = rule.text
          end
        end

        private

        def source
          @source ||=
            ::Nokogiri::XML(File.read("#{Cldr::Export::Data.dir}/supplemental/plurals.xml"))
        end

        def find_rules(locale)
          locale = locale.to_s

          # try to find exact match, then fall back
          node = find_rules_for_exact_locale(locale) ||
            find_rules_for_exact_locale(base_locale(locale)) ||
            find_rules_for_base_locale(locale)
            find_rules_for_base_locale(base_locale(locale))

          node / 'pluralRule'
        end

        def find_rules_for_exact_locale(locale)
          (source / 'plurals/pluralRules').find do |node|
            node.attributes['locales'].text
              .split(' ').map(&:downcase)
              .include?(locale.downcase)
          end
        end

        def find_rules_for_base_locale(locale)
          (source / 'plurals/pluralRules').find do |node|
            node.attributes['locales'].text
              .split(' ').map { |l| base_locale(l) }
              .include?(locale.downcase)
          end
        end

        def base_locale(locale)
          locale.split(/[_-]/).first
        end
      end
    end
  end
end
