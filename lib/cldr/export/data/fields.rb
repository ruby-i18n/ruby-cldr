# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class Fields < Base
        def initialize(locale)
          super
          update(fields: fields)
          deep_sort!
        end

        private

        def fields
          select("dates/fields/field").each_with_object({}) do |field_node, ret|
            type = field_node.attribute("type").value.underscore.to_sym
            ret[type] = field(field_node)
          end
        end

        def field(field_node)
          aliased = select_single(field_node, "alias")
          return xpath_to_key(aliased.attribute("path").value) if aliased

          result = {}

          unless (display_name = (field_node / "displayName").text).empty?
            result[:display_name] = display_name
          end

          unless (forms = relative_forms(field_node)).empty?
            result[:relative] = forms
          end

          unless (forms = relative_time_forms(field_node)).empty?
            result[:relative_time] = forms
          end

          result
        end

        def relative_forms(field_node)
          (field_node / "relative").each_with_object({}) do |relative_node, ret|
            type = relative_node.attribute("type").value.to_i
            ret[type] = relative_node.text
          end
        end

        def relative_time_forms(field_node)
          (field_node / "relativeTime").each_with_object({}) do |relative_time_node, ret|
            type = relative_time_node.attribute("type").value
            ret[type] = relative_time_patterns(relative_time_node)
          end
        end

        def relative_time_patterns(relative_time_node)
          (relative_time_node / "relativeTimePattern").each_with_object({}) do |relative_time_pattern_node, ret|
            count = relative_time_pattern_node.attribute("count").value
            ret[count] = relative_time_pattern_node.text
          end
        end

        def xpath_to_key(xpath)
          match = xpath.match(%r{^\.\./field\[@type='([^']*)'\]$})
          raise StandardError, "Didn't find expected data in alias path attribute: #{xpath}" unless match

          type = match[1].underscore
          :"fields.#{type}"
        end
      end
    end
  end
end
