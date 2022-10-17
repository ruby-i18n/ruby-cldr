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
            usage_type = usage_node.attribute("type").value.to_sym
            result[usage_type] = usage_node.xpath("contextTransform").each_with_object({}) do |transform_node, result|
              transform_type = transform_node.attribute("type").value.to_sym
              result[transform_type] = transform_node.content
            end
          end
        end
      end
    end
  end
end
