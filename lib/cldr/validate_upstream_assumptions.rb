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
      # the element chain covered by the handling gets added to this list.
      SUPPORTED_ALIAS_ELEMENT_CHAINS = [
        "/ldml/dates/calendars/calendar[@type=\"gregorian\"]/dayPeriods/dayPeriodContext[@type=\"format\"]/dayPeriodWidth[@type=\"narrow\"]/alias",
        "/ldml/dates/calendars/calendar[@type=\"gregorian\"]/dayPeriods/dayPeriodContext[@type=\"format\"]/dayPeriodWidth[@type=\"wide\"]/alias",
        "/ldml/dates/calendars/calendar[@type=\"gregorian\"]/dayPeriods/dayPeriodContext[@type=\"stand-alone\"]/dayPeriodWidth[@type=\"abbreviated\"]/alias",
        "/ldml/dates/calendars/calendar[@type=\"gregorian\"]/dayPeriods/dayPeriodContext[@type=\"stand-alone\"]/dayPeriodWidth[@type=\"narrow\"]/alias",
        "/ldml/dates/calendars/calendar[@type=\"gregorian\"]/dayPeriods/dayPeriodContext[@type=\"stand-alone\"]/dayPeriodWidth[@type=\"wide\"]/alias",
        "/ldml/dates/calendars/calendar[@type=\"gregorian\"]/days/dayContext[@type=\"format\"]/dayWidth[@type=\"abbreviated\"]/alias",
        "/ldml/dates/calendars/calendar[@type=\"gregorian\"]/days/dayContext[@type=\"format\"]/dayWidth[@type=\"narrow\"]/alias",
        "/ldml/dates/calendars/calendar[@type=\"gregorian\"]/days/dayContext[@type=\"format\"]/dayWidth[@type=\"short\"]/alias",
        "/ldml/dates/calendars/calendar[@type=\"gregorian\"]/days/dayContext[@type=\"stand-alone\"]/dayWidth[@type=\"abbreviated\"]/alias",
        "/ldml/dates/calendars/calendar[@type=\"gregorian\"]/days/dayContext[@type=\"stand-alone\"]/dayWidth[@type=\"short\"]/alias",
        "/ldml/dates/calendars/calendar[@type=\"gregorian\"]/days/dayContext[@type=\"stand-alone\"]/dayWidth[@type=\"wide\"]/alias",
        "/ldml/dates/calendars/calendar[@type=\"gregorian\"]/eras/eraNames/alias",
        "/ldml/dates/calendars/calendar[@type=\"gregorian\"]/eras/eraNarrow/alias",
        "/ldml/dates/calendars/calendar[@type=\"gregorian\"]/months/monthContext[@type=\"format\"]/monthWidth[@type=\"abbreviated\"]/alias",
        "/ldml/dates/calendars/calendar[@type=\"gregorian\"]/months/monthContext[@type=\"format\"]/monthWidth[@type=\"narrow\"]/alias",
        "/ldml/dates/calendars/calendar[@type=\"gregorian\"]/months/monthContext[@type=\"stand-alone\"]/monthWidth[@type=\"abbreviated\"]/alias",
        "/ldml/dates/calendars/calendar[@type=\"gregorian\"]/months/monthContext[@type=\"stand-alone\"]/monthWidth[@type=\"wide\"]/alias",
        "/ldml/dates/calendars/calendar[@type=\"gregorian\"]/quarters/quarterContext[@type=\"format\"]/quarterWidth[@type=\"abbreviated\"]/alias",
        "/ldml/dates/calendars/calendar[@type=\"gregorian\"]/quarters/quarterContext[@type=\"format\"]/quarterWidth[@type=\"narrow\"]/alias",
        "/ldml/dates/calendars/calendar[@type=\"gregorian\"]/quarters/quarterContext[@type=\"stand-alone\"]/quarterWidth[@type=\"abbreviated\"]/alias",
        "/ldml/dates/calendars/calendar[@type=\"gregorian\"]/quarters/quarterContext[@type=\"stand-alone\"]/quarterWidth[@type=\"wide\"]/alias",
        "/ldml/dates/fields/field[@type=\"day-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"day-short\"]/alias",
        "/ldml/dates/fields/field[@type=\"dayOfYear-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"dayOfYear-short\"]/alias",
        "/ldml/dates/fields/field[@type=\"dayperiod-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"dayperiod-short\"]/alias",
        "/ldml/dates/fields/field[@type=\"era-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"era-short\"]/alias",
        "/ldml/dates/fields/field[@type=\"fri-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"fri-short\"]/alias",
        "/ldml/dates/fields/field[@type=\"hour-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"hour-short\"]/alias",
        "/ldml/dates/fields/field[@type=\"minute-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"minute-short\"]/alias",
        "/ldml/dates/fields/field[@type=\"mon-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"mon-short\"]/alias",
        "/ldml/dates/fields/field[@type=\"month-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"month-short\"]/alias",
        "/ldml/dates/fields/field[@type=\"quarter-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"quarter-short\"]/alias",
        "/ldml/dates/fields/field[@type=\"sat-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"sat-short\"]/alias",
        "/ldml/dates/fields/field[@type=\"second-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"second-short\"]/alias",
        "/ldml/dates/fields/field[@type=\"sun-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"sun-short\"]/alias",
        "/ldml/dates/fields/field[@type=\"thu-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"thu-short\"]/alias",
        "/ldml/dates/fields/field[@type=\"tue-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"tue-short\"]/alias",
        "/ldml/dates/fields/field[@type=\"wed-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"wed-short\"]/alias",
        "/ldml/dates/fields/field[@type=\"week-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"week-short\"]/alias",
        "/ldml/dates/fields/field[@type=\"weekday-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"weekday-short\"]/alias",
        "/ldml/dates/fields/field[@type=\"weekdayOfMonth-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"weekdayOfMonth-short\"]/alias",
        "/ldml/dates/fields/field[@type=\"weekOfMonth-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"weekOfMonth-short\"]/alias",
        "/ldml/dates/fields/field[@type=\"year-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"year-short\"]/alias",
        "/ldml/dates/fields/field[@type=\"zone-narrow\"]/alias",
        "/ldml/dates/fields/field[@type=\"zone-short\"]/alias",
        "/ldml/listPatterns/listPattern[@type=\"or-narrow\"]/alias",
        "/ldml/listPatterns/listPattern[@type=\"or-short\"]/alias",
        "/ldml/listPatterns/listPattern[@type=\"standard-narrow\"]/alias",
        "/ldml/listPatterns/listPattern[@type=\"standard-short\"]/alias",
        "/ldml/listPatterns/listPattern[@type=\"unit-narrow\"]/alias",
        "/ldml/listPatterns/listPattern[@type=\"unit-short\"]/alias",
        "/ldml/listPatterns/listPattern[@type=\"unit\"]/alias",
        "/ldml/units/unitLength[@type=\"long\"]/alias",
        "/ldml/units/unitLength[@type=\"narrow\"]/alias",
        "/ldml/units/unitLength[@type=\"short\"]/unit[@type=\"duration-day-person\"]/alias",
        "/ldml/units/unitLength[@type=\"short\"]/unit[@type=\"duration-month-person\"]/alias",
        "/ldml/units/unitLength[@type=\"short\"]/unit[@type=\"duration-week-person\"]/alias",
        "/ldml/units/unitLength[@type=\"short\"]/unit[@type=\"duration-year-person\"]/alias",
        "/ldml/units/unitLength[@type=\"short\"]/unit[@type=\"energy-foodcalorie\"]/alias",
        "/ldml/units/unitLength[@type=\"short\"]/unit[@type=\"graphics-dot-per-centimeter\"]/alias",
        "/ldml/units/unitLength[@type=\"short\"]/unit[@type=\"graphics-dot-per-inch\"]/alias",
        "/ldml/units/unitLength[@type=\"short\"]/unit[@type=\"graphics-dot\"]/alias",
      ].freeze

      # Alias element chain that exist in the CLDR data, but we don't support, since we don't export this data.
      # Note: We don't have anything that will catch us if/when we start exporting this data.
      UNUSED_ALIAS_ELEMENT_CHAINS = File.readlines("lib/cldr/unused_alias_element_chains.txt").map(&:strip).reject { |line| line.start_with?("#") || line.empty? }.freeze

      def validate_aliases_only_in_expected_paths
        errors = []
        Cldr::Export.minimum_draft_status = Cldr::DraftStatus::CONTRIBUTED
        alias_paths = Cldr::Export::Data::RAW_DATA[:root].xpath("//alias").map do |child|
          Cldr::Export::Element.inheritance_chain(child)
        end.sort.uniq

        unknown_alias_paths = alias_paths - SUPPORTED_ALIAS_ELEMENT_CHAINS - UNUSED_ALIAS_ELEMENT_CHAINS

        unless unknown_alias_paths.empty?
          unknown_paths_string = unknown_alias_paths.join("\n\t")
          errors << StandardError.new("Found unexpected aliases. Make sure ruby-cldr supports them, then update SUPPORTED_ALIAS_ELEMENT_CHAINS or UNUSED_ALIAS_ELEMENT_CHAINS.\nFound an alias at the following unknown locations:\n\t#{unknown_paths_string}")
        end

        errors
      end
    end
  end
end
