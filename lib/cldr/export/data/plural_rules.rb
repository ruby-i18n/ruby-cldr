# frozen_string_literal: true

require "nokogiri"

module Cldr
  module Export
    module Data
      class PluralRules < Hash
        attr_reader :locale

        def initialize(locale)
          super()

          find_rules(locale).each_pair do |rule_type, rule_data|
            self[rule_type.to_sym] = rule_data.each_with_object({}) do |rule, ret|
              ret[rule.attributes["count"].text] = rule.text
            end
          end
        end

        private

        def sources
          @sources ||= ["plurals", "ordinals"].each_with_object({}) do |source_name, ret|
            ret[source_name] = Cldr::Export::DataFile.parse(File.read("#{Cldr::Export::Data::RAW_DATA.directory}/supplemental/#{source_name}.xml"))
          end
        end

        def find_rules(locale)
          locale = locale.to_s

          sources.each_with_object({}) do |(_file, source), ret|
            # try to find exact match, then fall back
            node = find_rules_for_exact_locale(locale, source) ||
              find_rules_for_exact_locale(base_locale(locale), source) ||
              find_rules_for_base_locale(locale, source) ||
              find_rules_for_base_locale(base_locale(locale), source)

            if node
              name = (source / "plurals").first.attributes["type"].value
              ret[name] = node / "pluralRule"
            end
          end
        end

        def find_rules_for_exact_locale(locale, source)
          (source / "plurals/pluralRules").find do |node|
            node.attributes["locales"].text
              .split(" ").map(&:downcase)
              .include?(locale.downcase)
          end
        end

        def find_rules_for_base_locale(locale, source)
          (source / "plurals/pluralRules").find do |node|
            node.attributes["locales"].text
              .split(" ").map { |l| base_locale(l) }
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
