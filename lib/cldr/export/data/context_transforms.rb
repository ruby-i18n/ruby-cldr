# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class ContextTransforms < Base
        def initialize(locale)
          super
          update(context_transforms: context_transforms)
        end

        private

        def context_transforms
          @context_transforms ||= select("contextTransforms/contextTransformUsage").each_with_object({}) do |usage_node, result|
            usage_type = usage_node.attribute("type").value.underscore.to_sym
            result[usage_type] = usage_node.xpath("contextTransform").each_with_object({}) do |transform_node, result|
              context_type = transform_node.attribute("type").value.underscore.to_sym
              transform_type = transform_node.content.underscore.gsub("firstword", "first_word")
              result[context_type] = transform_type
            end
          end
        end
      end
    end
  end
end
