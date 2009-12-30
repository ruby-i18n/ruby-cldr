module Cldr
  module Data
    autoload :Base,          'cldr/data/base'
    autoload :Calendars,     'cldr/data/calendars'
    autoload :Currencies,    'cldr/data/currencies'
    autoload :Delimiters,    'cldr/data/delimiters'
    autoload :Languages,     'cldr/data/languages'
    autoload :NumberSymbols, 'cldr/data/number_symbols'
    autoload :NumberFormats, 'cldr/data/number_formats'
    autoload :Territories,   'cldr/data/territories'
    autoload :Units,         'cldr/data/units'
    
    class << self
      def dir
        @dir ||= "#{File.dirname(__FILE__)}/../../vendor/cldr/data/core/main"
      end

      def dir=(dir)
        @dir = dir
      end
    end
  end
end