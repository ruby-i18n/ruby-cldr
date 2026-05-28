# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class LanguageInfo < Base
        def initialize
          super(nil)
          update(language_matching: language_matching)
          deep_sort!
        end

        private

        def language_matching
          doc.xpath("//languageMatching/languageMatches").each_with_object({}) do |matches_node, ret|
            matching_type = matches_node.attribute("type").to_s.underscore.to_sym
            ret[matching_type] = {
              paradigm_locales: paradigm_locales(matches_node),
              match_variables: match_variables(matches_node),
              language_matches: language_matches(matches_node),
            }
          end
        end

        def paradigm_locales(matches_node)
          locales_node = matches_node.xpath("./paradigmLocales").first
          return [] unless locales_node

          locales_str = locales_node.attribute("locales").to_s
          locales_str.split(" ").map { |locale| Cldr::Export.to_i18n(locale).to_s }
        end

        def match_variables(matches_node)
          matches_node.xpath("./matchVariable").each_with_object({}) do |var_node, hash|
            id = var_node.attribute("id").to_s
            value = var_node.attribute("value").to_s
            hash[id] = value
          end
        end

        def language_matches(matches_node)
          matches_node.xpath("./languageMatch").map do |match_node|
            {
              "desired" => Cldr::Export.to_i18n(match_node.attribute("desired")).to_s,
              "supported" => Cldr::Export.to_i18n(match_node.attribute("supported")).to_s,
              "distance" => match_node.attribute("distance").to_s.to_i,
              "oneway" => match_node.attribute("oneway").to_s == "true",
            }.reject { |_, v| v == false }
          end
        end
      end
    end
  end
end
