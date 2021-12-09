require 'core_ext/hash/symbolize_keys'

module Cldr
  autoload :Data,   'cldr/data'
  autoload :Export, 'cldr/export'
  autoload :Locale, 'cldr/locale'
  autoload :Format, 'cldr/format'

  class << self
    def fallbacks
      @@fallbacks ||= Cldr::Locale::Fallbacks.new
    end
  end
end
