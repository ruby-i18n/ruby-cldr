# frozen_string_literal: true

module Cldr
  class ValidateUpstreamAssumptions
    class << self
      def validate
        errors = []
        errors += validate_aliases_only_in_root_locale
        errors += validate_aliases_only_in_expected_paths
        errors.each do |error|
          puts(error.message)
        end
        exit(errors.empty? ? 0 : 1)
      end

      private

      def validate_aliases_only_in_root_locale
        errors = []
        Cldr::Export.minimum_draft_status = Cldr::DraftStatus::CONTRIBUTED
        Cldr::Export::Data::RAW_DATA.locales.each do |locale|
          aliases = Cldr::Export::Data::RAW_DATA[locale].xpath("//alias")
          unless aliases.empty? || locale == :root
            errors << StandardError.new("`#{locale}` has aliases but is not `root`")
          end
        end
        errors
      end

      EXPECTED_ALIAS_LOCATIONS = [
        "/ldml/dates/calendars/calendar/dayPeriods/dayPeriodContext/dayPeriodWidth/alias",
        "/ldml/dates/calendars/calendar/days/dayContext/dayWidth/alias",

        # Currently only used by `islamic-*` calendars, which we don't export yet.
        # https://github.com/ruby-i18n/ruby-cldr/issues/168
        "/ldml/dates/calendars/calendar/eras/alias",

        "/ldml/dates/calendars/calendar/eras/eraNames/alias",
        "/ldml/dates/calendars/calendar/eras/eraNarrow/alias",
        "/ldml/dates/calendars/calendar/months/monthContext/monthWidth/alias",
        "/ldml/dates/calendars/calendar/quarters/quarterContext/quarterWidth/alias",
      ].freeze

      def validate_aliases_only_in_expected_paths
        errors = []
        Cldr::Export.minimum_draft_status = Cldr::DraftStatus::CONTRIBUTED
        alias_paths = Cldr::Export::Data::RAW_DATA[:root].xpath("//alias").map do |child|
          child.path.gsub(/\[\d+\]/, "")
        end.sort.uniq

        unknown_alias_paths = alias_paths - EXPECTED_ALIAS_LOCATIONS

        if unknown_alias_paths
          unknown_paths_string = unknown_alias_paths.join("\n\t")
          errors << StandardError.new("Found unexpected aliases. Make sure ruby-cldr supports them, then update EXPECTED_ALIAS_LOCATIONS.\nFound an alias at the following unknown locations:\n\t#{unknown_paths_string}")
        end

        errors
      end
    end
  end
end
