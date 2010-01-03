require 'core_ext/string/camelize'

module Cldr
  module Data
    autoload :Base,          'cldr/data/base'
    autoload :Export,        'cldr/data/export'
    autoload :Calendars,     'cldr/data/calendars'
    autoload :Currencies,    'cldr/data/currencies'
    autoload :Delimiters,    'cldr/data/delimiters'
    autoload :Languages,     'cldr/data/languages'
    autoload :Numbers,       'cldr/data/numbers'
    autoload :Territories,   'cldr/data/territories'
    autoload :Units,         'cldr/data/units'

    class << self
      def dir
        @dir ||= File.expand_path(File.dirname(__FILE__) + '/../../vendor/cldr/data/core/main')
      end

      def dir=(dir)
        @dir = dir
      end

      def locales
        Dir["#{dir}/*.xml"].map { |path| path =~ /([\w_-]+)\.xml/ && $1 }
      end

      def components
        self.constants.sort - [:Base, :Export]
      end

      def export(options = {}, &block)
        format     = options[:format]     || 'yaml'
        locales    = options[:locales]    || self.locales
        components = options[:components] || self.components

        Export.const_get(format.camelize).new.export(locales, components, &block)
      end
    end
  end
end