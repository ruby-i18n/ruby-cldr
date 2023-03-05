# frozen_string_literal: true

require "core_ext/hash/symbolize_keys"

module Cldr
  autoload :Download,                    "cldr/download"
  autoload :DraftStatus,                 "cldr/draft_status"
  autoload :Export,                      "cldr/export"
  autoload :Format,                      "cldr/format"
  autoload :Ldml,                        "cldr/ldml"
  autoload :Locale,                      "cldr/locale"
  autoload :Validate,                    "cldr/validate"
  autoload :ValidateUpstreamAssumptions, "cldr/validate_upstream_assumptions"

  class << self
    def fallbacks
      @@fallbacks ||= Cldr::Locale::Fallbacks.new
    end
  end
end
