# frozen_string_literal: true

module Cldr
  module Export
    class Ruby
      def export(locale, component, options = {})
        data = Export.data(component, locale, options)
        data = data.to_ruby if data.respond_to?(:to_ruby)
        unless data.empty?
          path = Export.path(locale, component, "rb")
          Export.write(path, data) 
          yield(component, locale, path) if block_given?
          data
        end
      end
    end
  end
end
