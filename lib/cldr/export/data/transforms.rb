# encoding: UTF-8
# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class Transforms < Base
        attr_reader :transform_file

        def initialize(transform_file)
          super(nil)  # no locale
          @transform_file = transform_file
          update(transforms: transforms)
        end

        protected

        def doc
          Cldr::Export::DataFile.parse(File.read(transform_file))
        end

        private

        def transforms
          doc.xpath("supplementalData/transforms/transform").map do |transform_node|
            {
              source: transform_node.attribute("source").value,
              target: transform_node.attribute("target").value,
              variant: get_variant(transform_node),
              direction: transform_node.attribute("direction").value,
              rules: rules(transform_node),
            }
          end
        end

        def get_variant(node)
          node.attribute("variant")&.value
        end

        def rules(transform_node)
          rules = fix_rule_wrapping(
            doc.xpath("#{transform_node.path}/tRule").flat_map do |rule_node|
              fix_rule(rule_node.content).split("\n").map(&:strip)
            end
          )

          rules.reject do |rule|
            rule.strip.empty? || rule.strip.start_with?("#")
          end
        end

        def fix_rule_wrapping(rules)
          wrap = false

          rules.each_with_object([]) do |rule, ret|
            if wrap
              ret.last.sub!(/\\\z/, rule)
            else
              ret << rule
            end

            wrap = rule.end_with?("\\")
          end
        end

        def fix_rule(rule)
          rule
            .gsub("←", "<")
            .gsub("→", ">")
            .gsub("↔", "<>")
        end
      end
    end
  end
end
