require 'core_ext/string/camelize'

module Cldr
  module Export
    module Data
      autoload :Base,             'cldr/export/data/base'
      autoload :Calendars,        'cldr/export/data/calendars'
      autoload :Currencies,       'cldr/export/data/currencies'
      autoload :CurrencyDigitsAndRounding,    'cldr/export/data/currency_digits_and_rounding'
      autoload :Delimiters,       'cldr/export/data/delimiters'
      autoload :Characters,       'cldr/export/data/characters'
      autoload :Languages,        'cldr/export/data/languages'
      autoload :Numbers,          'cldr/export/data/numbers'
      autoload :Plurals,          'cldr/export/data/plurals'
      autoload :Territories,      'cldr/export/data/territories'
      autoload :Timezones,        'cldr/export/data/timezones'
      autoload :Metazones,        'cldr/export/data/metazones'
      autoload :WindowsZones,     'cldr/export/data/windows_zones'
      autoload :Units,            'cldr/export/data/units'
      autoload :Lists,            'cldr/export/data/lists'
      autoload :Layout,           'cldr/export/data/layout'
      autoload :Rbnf,             'cldr/export/data/rbnf'
      autoload :RbnfRoot,         'cldr/export/data/rbnf_root'
      autoload :NumberingSystems, 'cldr/export/data/numbering_systems'
      autoload :SegmentsRoot,     'cldr/export/data/segments_root'

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
end
