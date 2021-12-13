# frozen_string_literal: true

module Cldr
  module Export
    module Code
      # autoload :Base,          'cldr/export/code/base'
      # autoload :Calendars,     'cldr/export/code/calendars'
      # autoload :Currencies,    'cldr/export/code/currencies'
      # autoload :Delimiters,    'cldr/export/code/delimiters'
      # autoload :Languages,     'cldr/export/code/languages'
      autoload :Numbers,       "cldr/export/code/numbers"
      # autoload :Plurals,       'cldr/export/code/plurals'
      # autoload :Territories,   'cldr/export/code/territories'
      # autoload :Timezones,     'cldr/export/code/timezones'
      # autoload :Units,         'cldr/export/code/units'
      #
      # class << self
      #   def dir
      #     @dir ||= File.expand_path('./vendor/cldr/common')
      #   end
      #
      #   def dir=(dir)
      #     @dir = dir
      #   end
      #
      #   def locales
      #     Dir["#{dir}/main/*.xml"].map { |path| path =~ /([\w_-]+)\.xml/ && $1 }
      #   end
      #
      #   def components
      #     self.constants.sort - [:Base, :Export]
      #   end
      # end
    end
  end
end