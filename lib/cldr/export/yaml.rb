# frozen_string_literal: true

require "yaml"

module Cldr
  module Export
    class Yaml

      def export(locale, component, options = {})
        data = Export.data(component, locale, options)
        data.deep_prune!
        unless data.empty?
          data = data.deep_stringify_keys if data.respond_to?(:deep_stringify_keys)
          data = data.deep_sort if data.respond_to?(:deep_sort)
          data = { Cldr::Export.to_i18n(locale).to_s => data } if locale != ""
          path = Export.path(locale, component, "yml")
          Export.write(path, yaml(data))
          yield(component, locale, path) if block_given?
          data
        end
      end

      def yaml(data)
        data.to_yaml
      end
    end
  end
end
