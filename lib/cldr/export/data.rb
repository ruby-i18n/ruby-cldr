# frozen_string_literal: true

require "core_ext/string/camelize"

module Cldr
  module Export
    module Data
      autoload :Aliases,                   "cldr/export/data/aliases"
      autoload :Base,                      "cldr/export/data/base"
      autoload :Calendars,                 "cldr/export/data/calendars"
      autoload :Characters,                "cldr/export/data/characters"
      autoload :CountryCodes,              "cldr/export/data/country_codes"
      autoload :Currencies,                "cldr/export/data/currencies"
      autoload :CurrencyDigitsAndRounding, "cldr/export/data/currency_digits_and_rounding"
      autoload :Delimiters,                "cldr/export/data/delimiters"
      autoload :Fields,                    "cldr/export/data/fields"
      autoload :Languages,                 "cldr/export/data/languages"
      autoload :Layout,                    "cldr/export/data/layout"
      autoload :LikelySubtags,             "cldr/export/data/likely_subtags"
      autoload :Lists,                     "cldr/export/data/lists"
      autoload :Metazones,                 "cldr/export/data/metazones"
      autoload :NumberingSystems,          "cldr/export/data/numbering_systems"
      autoload :Numbers,                   "cldr/export/data/numbers"
      autoload :ParentLocales,             "cldr/export/data/parent_locales"
      autoload :Plurals,                   "cldr/export/data/plurals"
      autoload :PluralRules,               "cldr/export/data/plural_rules"
      autoload :Rbnf,                      "cldr/export/data/rbnf"
      autoload :RbnfRoot,                  "cldr/export/data/rbnf_root"
      autoload :RegionCurrencies,          "cldr/export/data/region_currencies"
      autoload :SegmentsRoot,              "cldr/export/data/segments_root"
      autoload :Subdivisions,              "cldr/export/data/subdivisions"
      autoload :Territories,               "cldr/export/data/territories"
      autoload :TerritoriesContainment,    "cldr/export/data/territories_containment"
      autoload :Timezones,                 "cldr/export/data/timezones"
      autoload :Units,                     "cldr/export/data/units"
      autoload :Variables,                 "cldr/export/data/variables"
      autoload :WindowsZones,              "cldr/export/data/windows_zones"
      autoload :Transforms,                "cldr/export/data/transforms"

      RAW_DATA = Cldr::Export::FileBasedDataSet.new(directory: File.expand_path("./vendor/cldr/common"))

      class << self
        def components
          constants.sort - [:Base, :Export, :RAW_DATA]
        end
      end
    end
  end
end
