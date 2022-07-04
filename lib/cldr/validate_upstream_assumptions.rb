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

      # Aliases need explicit special handling. Once that handling has been added,
      # the path covered by the handling gets added to this list.
      SUPPORTED_ALIAS_LOCATIONS = [
        "/ldml/dates/calendars/calendar/dayPeriods/dayPeriodContext/dayPeriodWidth/alias",
        "/ldml/dates/calendars/calendar/days/dayContext/dayWidth/alias",
        "/ldml/dates/calendars/calendar/months/monthContext/monthWidth/alias",
        "/ldml/dates/calendars/calendar/quarters/quarterContext/quarterWidth/alias",
        "/ldml/dates/fields/field/alias",
        "/ldml/listPatterns/listPattern/alias",
        "/ldml/units/unitLength/alias",
        "/ldml/units/unitLength/unit/alias",
      ].freeze

      # Alias locations that exist, but we don't support, since we don't export this data.
      # Note: We don't have anything that will catch us if/when we start exporting this data.
      UNUSED_ALIAS_LOCATIONS = [
        "/ldml/dates/calendars/calendar/cyclicNameSets/alias",
        "/ldml/dates/calendars/calendar/cyclicNameSets/cyclicNameSet/alias",
        "/ldml/dates/calendars/calendar/cyclicNameSets/cyclicNameSet/cyclicNameContext/cyclicNameWidth/alias",
      ].freeze

      def validate_aliases_only_in_expected_paths
        errors = []
        Cldr::Export.minimum_draft_status = Cldr::DraftStatus::CONTRIBUTED
        alias_paths = Cldr::Export::Data::RAW_DATA[:root].xpath("//alias").map do |child|
          child.path.gsub(/\[\d+\]/, "")
        end.sort.uniq

        unknown_alias_paths = alias_paths - SUPPORTED_ALIAS_LOCATIONS - UNUSED_ALIAS_LOCATIONS

        if unknown_alias_paths
          unknown_paths_string = unknown_alias_paths.join("\n\t")
          errors << StandardError.new("Found unexpected aliases. Make sure ruby-cldr supports them, then update SUPPORTED_ALIAS_LOCATIONS or UNUSED_ALIAS_LOCATIONS.\nFound an alias at the following unknown locations:\n\t#{unknown_paths_string}")
        end

        errors
      end
    end
  end
end
