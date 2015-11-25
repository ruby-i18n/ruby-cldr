require 'nokogiri'

module Cldr
  module Export
    module Data
      class PluralRules < Hash
        attr_reader :locale

        def initialize(locale)
          find_rules(locale).each_pair do |rule_type, rule_data|
            self[rule_type.to_sym] = rule_data.inject({}) do |ret, rule|
              ret[rule.attributes['count'].text] = rule.text
              ret
            end
          end
        end

        private

        def sources
          @sources ||= ['plurals', 'ordinals'].inject({}) do |ret, source_name|
            ret[source_name] = ::Nokogiri::XML(
              File.read("#{Cldr::Export::Data.dir}/supplemental/#{source_name}.xml")
            )
            ret
          end
        end

        def find_rules(locale)
          locale = locale.to_s

          sources.inject({}) do |ret, (file, source)|
            # try to find exact match, then fall back
            node = find_rules_for_exact_locale(locale, source) ||
              find_rules_for_exact_locale(base_locale(locale), source) ||
              find_rules_for_base_locale(locale, source) ||
              find_rules_for_base_locale(base_locale(locale), source)

            if node
              name = (source / 'plurals').first.attributes['type'].value
              ret[name] = node / 'pluralRule'
            end

            ret
          end
        end

        def find_rules_for_exact_locale(locale, source)
          (source / 'plurals/pluralRules').find do |node|
            node.attributes['locales'].text
              .split(' ').map(&:downcase)
              .include?(locale.downcase)
          end
        end

        def find_rules_for_base_locale(locale, source)
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
