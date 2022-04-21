# frozen_string_literal: true

require "fileutils"

module Cldr
  module Export
    module Data
      class Plurals < Hash
        autoload :Grammar,     "cldr/export/data/plurals/grammar"
        autoload :Parser,      "cldr/export/data/plurals/grammar"
        autoload :Rules,       "cldr/export/data/plurals/rules"
        autoload :Rule,        "cldr/export/data/plurals/rules"
        autoload :Proposition, "cldr/export/data/plurals/rules"
        autoload :Expression,  "cldr/export/data/plurals/rules"

        class << self
          def rules
            @@rules ||= Rules.parse(File.read("#{Cldr::Export::Data.dir}/supplemental/plurals.xml"))
          end
        end

        attr_reader :locale

        def initialize(locale)
          super()

          @locale = locale
          merge!(rule ? to_hash : {})
        end

        def to_hash
          rule_rb = rule ? rule.to_ruby : nil
          { keys: (rule || {}).keys, rule: rule_rb }
        end

        def rule
          @rule = Plurals.rules.rule(locale)
        end
      end
    end
  end
end
