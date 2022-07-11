# frozen_string_literal: true

require "core_ext/hash/symbolize_keys"

module Cldr
  autoload :Data,         "cldr/data"
  autoload :DraftStatus,  "cldr/draft_status"
  autoload :Export,       "cldr/export"
  autoload :Ldml,         "cldr/ldml"
  autoload :Locale,       "cldr/locale"
  autoload :Format,       "cldr/format"

  class << self
    def fallbacks
      @@fallbacks ||= Cldr::Locale::Fallbacks.new
    end
  end
end
