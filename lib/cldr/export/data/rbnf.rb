# encoding: utf-8
# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class Rbnf < Base
        def initialize(*args)
          super
          update(rbnf: { grouping: rule_groups })
        end

        private

        def rule_groups
          grouping_nodes = select("rbnf/rulesetGrouping")
          return {} if grouping_nodes.empty?

          grouping_nodes.map do |grouping_node|
            type = grouping_node.attribute("type").value.underscore
            next if type == "numbering_system_rules" && !is_a?(RbnfRoot)

            [
              type,
              (grouping_node / "ruleset").map do |ruleset_node|
                [
                  ruleset_node.attribute("type").value,
                  rule_set(ruleset_node),
                ]
              end.to_h,
            ]
          end.compact.to_h
        end

        def rule_set(ruleset_node)
          attrs = {
            rules: (ruleset_node / "rbnfrule").map do |rule_node|
              radix = if (radix_attr = rule_node.attribute("radix"))
                cast_value(radix_attr.value)
              end

              attrs = {
                rule: fix_rule(rule_node.text),
              }

              attrs[:radix] = radix if radix

              [
                cast_value(rule_node.attribute("value").value).to_s,
                attrs,
              ]
            end.to_h,
          }

          access = ruleset_node.attribute("access")
          attrs[:access] = access.value if access
          attrs
        end

        def cast_value(val)
          if val =~ /\A[\d]+\z/
            val.to_i
          else
            val
          end
        end

        def fix_rule(rule)
          rule.gsub(/\A'/, "").gsub("←", "<").gsub("→", ">")
        end
      end
    end
  end
end
