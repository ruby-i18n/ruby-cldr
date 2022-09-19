# frozen_string_literal: true

require "yaml"

module Cldr
  module Export
    class Yaml
      def export(locale, component, options = {})
        data = Export.data(component, locale, options).to_h
        data = format(data, locale, component)
        unless data.empty?
          path = Export.path(locale, component, "yml")
          Export.write(path, data.to_yaml)
          yield(component, locale, path) if block_given?
          data
        end
      end

      private

      UNSORTED_COMPONENTS = [:Calendars, :Delimiters, :Lists].freeze

      def format(data, locale, component)
        data.deep_prune!
        unless data.empty?
          data = data.deep_stringify_keys if data.respond_to?(:deep_stringify_keys)
          if data.respond_to?(:deep_sort)
            sorted_data = data.deep_sort
            raise "#{component} data for #{locale} is not sorted." unless sorted_data.to_s == data.to_s || UNSORTED_COMPONENTS.include?(component)
          end

          data = { locale.to_s => data } unless locale.nil?
        end
        data
      end
    end
  end
end
