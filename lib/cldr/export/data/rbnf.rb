# encoding: UTF-8

module Cldr
  module Export
    module Data
      class Rbnf < Base

        def initialize(*args)
          super
          update(:rbnf => { :grouping => rule_groups })
        end

        def rule_groups
          if File.exist?(path)
            select("rbnf/rulesetGrouping").map do |grouping_node|
              {
                :type => grouping_node.attribute("type").value,
                :ruleset => (grouping_node / "ruleset").map do |ruleset_node|
                  rule_set(ruleset_node)
                end
              }
            end
          else
            {}
          end
        end

        def rule_set(ruleset_node)
          attrs = {
            :type => ruleset_node.attribute("type").value,
            :rules => (ruleset_node / "rbnfrule").map do |rule_node|
              radix = if radix_attr = rule_node.attribute("radix")
                radix_attr.value
              else
                nil
              end
              
              attrs = {
                :value => rule_node.attribute("value").value,
                :rule => fix_rule(rule_node.text)
              }

              attrs[:radix] = radix if radix
              attrs
            end
          }

          access = ruleset_node.attribute("access")
          attrs[:access] = access.value if access
          attrs
        end

        def fix_rule(rule)
          rule.gsub(/\A'/, '').gsub("←", '<').gsub("→", '>')
        rescue => e
          binding.pry
        end

        def path
          @path ||= "#{Cldr::Export::Data.dir}/rbnf/#{locale.to_s.gsub('-', '_')}.xml"
        end

      end
    end
  end
end