class Cldr
  module Export
    class Ruby
      def export(locale, component)
        data = Export.data(component, locale)
        data = data.to_ruby if data.respond_to?(:to_ruby)
        unless data.empty?
          path = Export.path(locale, component, 'rb')
          Export.write(path, data) 
          yield(component, locale, path) if block_given?
        end
      end
    end
  end
end
