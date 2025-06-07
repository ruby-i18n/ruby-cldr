# frozen_string_literal: true

class DeepValidateKeys
  class << self
    # Keys must be in snake_case, unless specifically exempted.
    def validate(hash, component, key_path = [])
      hash.each do |key, value|
        full_path = key_path + [key]
        raise ArgumentError, "Invalid key: #{full_path} in #{component}" unless key.to_s == key.to_s.underscore ||
          SNAKE_CASE_EXCEPTIONS.fetch(component, []).any? { |exception| paths_match(exception, full_path) }

        validate(value, component, full_path) if value.is_a?(Hash)
      end
    end

    private

    SNAKE_CASE_EXCEPTIONS = {
      Aliases: [
        ["aliases", "language", "."],
        ["aliases", "territory", "."],
      ],
      Calendars: [["calendars", "gregorian", "additional_formats", "."]],
      Currencies: [["currencies", "."]],
      CountryCodes: [["country_codes", "."]],
      CurrencyDigitsAndRounding: [["."]],
      Fields: [["*", "relative", "."]],
      Languages: [["languages", "."]],
      LikelySubtags: [["subtags", "."]],
      Metazones: [
        ["primaryzones", "."],
        ["timezones", "."],
      ],
      RegionCurrencies: [["region_currencies", "."]],
      ParentLocales: [["."]],
      Rbnf: [
        ["rbnf", "grouping", "ordinal_rules", "."],
        ["rbnf", "grouping", "ordinal_rules", ".", "rules", "."],
        ["rbnf", "grouping", "spellout_rules", "."],
        ["rbnf", "grouping", "spellout_rules", ".", "rules", "."],
      ],
      RbnfRoot: [
        ["rbnf", "grouping", "ordinal_rules", "."],
        ["rbnf", "grouping", "ordinal_rules", ".", "rules", "."],
        ["rbnf", "grouping", "numbering_system_rules", "."],
        ["rbnf", "grouping", "numbering_system_rules", ".", "rules", "."],
        ["rbnf", "grouping", "spellout_rules", "."],
        ["rbnf", "grouping", "spellout_rules", ".", "rules", "."],
      ],
      Subdivisions: [["subdivisions", "."]],
      Territories: [["territories", "."]],
      TerritoriesContainment: [["territories", "."]],
      Timezones: [
        ["metazones", "."],
        ["timezones", "."],
      ],
      WindowsZones: [
        ["."],
        [".", "."],
      ],
    }

    def paths_match(pattern, key)
      raise NotImplementedError, "Multiple * in pattern is unsupported" if pattern.count { |element| element == "*" } > 1

      pattern_index = 0
      key_index = 0

      while pattern_index < pattern.length
        if pattern[pattern_index] == "*"
          pattern_index += 1
          return true if pattern_index == pattern.length # "*" at the end of a pattern matches everything

          last_match = key.rindex(pattern[pattern_index]) # "*" is greedy, so we need to find the last match
          return false if last_match.nil?

          key_index = last_match
        elsif !(pattern[pattern_index] == key[key_index] || (pattern[pattern_index] == "." && key_index < key.length))
          return false
        else
          pattern_index += 1
          key_index += 1
        end
      end

      return false unless key_index == key.length

      true
    end
  end
end
