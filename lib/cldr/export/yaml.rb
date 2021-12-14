# frozen_string_literal: true

require "yaml"

module Cldr
  module Export
    class Yaml
      def export(locale, component, options = {})
        data = Export.data(component, locale, options).to_h
        data = format(data, locale)
        unless data.empty?
          path = Export.path(locale, component, "yml")
          Export.write(path, data.to_yaml)
          yield(component, locale, path) if block_given?
          data
        end
      end

      private

      def format(data, locale)
        data.deep_prune!
        unless data.empty?
          data = data.deep_stringify_keys if data.respond_to?(:deep_stringify_keys)
          data = data.deep_sort if data.respond_to?(:deep_sort)
          data = { Cldr::Export.to_i18n(locale).to_s => data } if locale != ""
        end
        data
      end
    end
  end
end
