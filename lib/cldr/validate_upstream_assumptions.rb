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
      SUPPORTED_ALIAS_ELEMENT_CHAINS = [ # rubocop:disable Metrics/CollectionLiteralLength
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
        "/ldml/numbers/currencyFormats[@numberSystem=\"adlm\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"arab\"]/currencyFormatLength/currencyFormat[@type=\"accounting\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"arabext\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"bali\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"beng\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"brah\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"cakm\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"cham\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"deva\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"fullwide\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"gong\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"gonm\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"gujr\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"guru\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"hanidec\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"java\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"kali\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"khmr\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"knda\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"lana\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"lanatham\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"laoo\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"latn\"]/currencyFormatLength/currencyFormat[@type=\"accounting\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"lepc\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"limb\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"mlym\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"mong\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"mtei\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"mymr\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"mymrshan\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"nkoo\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"olck\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"orya\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"osma\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"rohg\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"saur\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"shrd\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"sora\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"sund\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"takr\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"talu\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"tamldec\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"telu\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"thai\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"tibt\"]/alias",
        "/ldml/numbers/currencyFormats[@numberSystem=\"vaii\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"adlm\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"arab\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"arabext\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"bali\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"beng\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"brah\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"cakm\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"cham\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"deva\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"fullwide\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"gong\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"gonm\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"gujr\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"guru\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"hanidec\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"java\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"kali\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"khmr\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"knda\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"lana\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"lanatham\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"laoo\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"latn\"]/decimalFormatLength[@type=\"long\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"lepc\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"limb\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"mlym\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"mong\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"mtei\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"mymr\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"mymrshan\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"nkoo\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"olck\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"orya\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"osma\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"rohg\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"saur\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"shrd\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"sora\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"sund\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"takr\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"talu\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"tamldec\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"telu\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"thai\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"tibt\"]/alias",
        "/ldml/numbers/decimalFormats[@numberSystem=\"vaii\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"adlm\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"arabext\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"bali\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"beng\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"brah\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"cakm\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"cham\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"deva\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"fullwide\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"gong\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"gonm\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"gujr\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"guru\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"hanidec\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"java\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"kali\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"khmr\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"knda\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"lana\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"lanatham\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"laoo\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"lepc\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"limb\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"mlym\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"mong\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"mtei\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"mymr\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"mymrshan\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"nkoo\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"olck\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"orya\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"osma\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"rohg\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"saur\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"shrd\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"sora\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"sund\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"takr\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"talu\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"tamldec\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"telu\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"thai\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"tibt\"]/alias",
        "/ldml/numbers/percentFormats[@numberSystem=\"vaii\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"adlm\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"arab\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"arabext\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"bali\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"beng\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"brah\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"cakm\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"cham\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"deva\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"fullwide\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"gong\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"gonm\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"gujr\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"guru\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"hanidec\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"java\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"kali\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"khmr\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"knda\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"lana\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"lanatham\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"laoo\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"lepc\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"limb\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"mlym\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"mong\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"mtei\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"mymr\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"mymrshan\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"nkoo\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"olck\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"orya\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"osma\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"rohg\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"saur\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"shrd\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"sora\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"sund\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"takr\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"talu\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"tamldec\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"telu\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"thai\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"tibt\"]/alias",
        "/ldml/numbers/scientificFormats[@numberSystem=\"vaii\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"adlm\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"bali\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"beng\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"brah\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"cakm\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"cham\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"deva\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"fullwide\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"gong\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"gonm\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"gujr\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"guru\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"hanidec\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"hmnp\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"java\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"kali\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"khmr\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"knda\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"lana\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"lanatham\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"laoo\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"lepc\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"limb\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"mlym\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"mong\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"mtei\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"mymr\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"mymrshan\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"nkoo\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"olck\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"orya\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"osma\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"rohg\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"saur\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"shrd\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"sora\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"sund\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"takr\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"talu\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"tamldec\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"telu\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"thai\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"tibt\"]/alias",
        "/ldml/numbers/symbols[@numberSystem=\"vaii\"]/alias",
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

        found_in_both = SUPPORTED_ALIAS_ELEMENT_CHAINS & UNUSED_ALIAS_ELEMENT_CHAINS
        raise "Found #{found_in_both.size} alias paths in both the supported and unused alias element chains. Example: `#{found_in_both.first}`" if found_in_both.any?

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
