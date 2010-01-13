require 'core_ext/string/camelize'

class Cldr
  module Data
    autoload :Base,          'cldr/data/base'
    autoload :Calendars,     'cldr/data/calendars'
    autoload :Currencies,    'cldr/data/currencies'
    autoload :Delimiters,    'cldr/data/delimiters'
    autoload :Languages,     'cldr/data/languages'
    autoload :Numbers,       'cldr/data/numbers'
    autoload :Plurals,       'cldr/data/plurals'
    autoload :Territories,   'cldr/data/territories'
    autoload :Timezones,     'cldr/data/timezones'
    autoload :Units,         'cldr/data/units'

    class << self
      def dir
        @dir ||= File.expand_path('./vendor/cldr/common')
      end
      
      def dir=(dir)
        @dir = dir
      end

      def locales
        Dir["#{dir}/main/*.xml"].map { |path| path =~ /([\w_-]+)\.xml/ && $1 }
      end

      def components
        self.constants.sort - [:Base, :Export]
      end
    end
  end
end