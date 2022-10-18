# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class Numbers < Base
        def initialize(locale)
          super
          update(
            numbers: number_systems,
          )
          deep_sort!
        end

        private

        FORMAT_TYPES = ["currency", "decimal", "percent", "scientific"].freeze

        def number_systems
          number_systems = select("/descendant::*[attribute::numberSystem]").map { |node| node["numberSystem"] }.uniq.map(&:to_sym)
          number_systems.to_h do |number_system|
            children = {
              formats: FORMAT_TYPES.to_h do |type|
                results = { patterns: format(number_system, type) }
                results.merge!({ unit: unit(number_system) }) if type == "currency"
                [type.to_sym, results]
              end,
              symbols: symbols(number_system),
            }
            [number_system, children]
          end
        end

        def symbols(number_system)
          number_system_node = select_single("numbers/symbols[@numberSystem=\"#{number_system}\"]")

          aliased = select_single(number_system_node, "alias")
          if aliased
            return xpath_to_symbols_alias(aliased["path"])
          end

          select("numbers/symbols[@numberSystem=\"#{number_system}\"]/*").each_with_object({}) do |node, result|
            result[name(node).to_sym] = node.content
          end
        end

        def format(number_system, type)
          number_system_node = select_single("numbers/#{type}Formats[@numberSystem=\"#{number_system}\"]")
          return {} unless number_system_node

          aliased = select_single(number_system_node, "alias")
          if aliased
            return xpath_to_format_alias(aliased["path"], type)
          end

          result = select("numbers/#{type}Formats[@numberSystem=\"#{number_system}\"]/#{type}FormatLength").each_with_object({}) do |format_length_node, format_result|
            format_length_key = format_length_node["type"]&.to_sym || default_format_length_type

            aliased = select_single(format_length_node, "alias")
            if aliased
              format_result[format_length_key] = xpath_to_format_length_alias(aliased["path"], number_system, type)
              next
            end

            format_result[format_length_key] = if format_length_key == default_format_length_type
              parse_default_format_length_node(number_system, format_length_node, type)
            else
              parse_format_length_node(format_length_node, type)
            end
          end

          result
        end

        def parse_default_format_length_node(number_system, format_length_node, type)
          result = {}
          select(format_length_node, "#{type}Format").each do |format_node|
            format_key = format_node["type"]&.to_sym || default_format_type

            if (aliased = select_single(format_node, "alias"))
              result[format_key] = xpath_to_default_format_length_node_alias(aliased["path"], number_system, default_format_length_type)
            else
              pattern_node = select_single(format_node, "pattern[not(@alt)]") # https://github.com/ruby-i18n/ruby-cldr/issues/125
              next unless pattern_node

              result[format_key] = pattern_node.content
            end
          end
          result
        end

        def parse_format_length_node(format_length_node, type)
          result = {}
          select(format_length_node, "#{type}Format").each do |format_node|
            format_key = format_node["type"]&.to_sym || default_format_type

            result[format_key] ||= select(format_node, "pattern").each_with_object({}) do |pattern_node, pattern_result|
              pattern_key = pattern_node["type"]&.to_sym || default_pattern_type
              pattern_count = pattern_node["count"]&.to_sym

              if pattern_count
                if pattern_result[pattern_key].nil?
                  pattern_result[pattern_key] ||= {}
                elsif !pattern_result[pattern_key].is_a?(Hash)
                  raise "can't parse patterns with and without 'count' attribute in the same section"
                end

                pattern_result[pattern_key][pattern_count] = pattern_node.content
              else
                pattern_result[pattern_key] = pattern_node.content
              end
            end
          end
          result
        end

        def default_format_length_type
          # TODO: It would be better is this were one of the valid values for the type attribute
          # <!ATTLIST decimalFormatLength type (full | long | medium | short) #IMPLIED >
          # But I haven't been able to figure out what the default is.
          @default_format_length_type ||= :default
        end

        def default_format_type
          @default_format_type ||= begin
            # Verify that the default format type has not changed / is the same for all the types
            ldml_dtd_file = File.read("vendor/cldr/common/dtd/ldml.dtd")
            FORMAT_TYPES.each do |type|
              next if ldml_dtd_file.include?("<!ATTLIST #{type}Format type NMTOKEN \"standard\" >")

              raise "The default type for #{type}Format has changed. Some code will need to be updated."
            end
            :standard
          end
        end

        def default_pattern_type
          @default_pattern_type ||= begin
            ldml_dtd_file = File.read("vendor/cldr/common/dtd/ldml.dtd")
            ldml_dtd_file.match("<!ATTLIST pattern type NMTOKEN \"([^\"]+)\" >")[1]
          end.to_sym
        end

        def xpath_to_default_format_length_node_alias(xpath, number_system, format_length_key)
          match = xpath.match(%r{\.\./currencyFormat\[@type='(\w+)+'\]})
          raise "Alias doesn't match expected pattern: #{xpath}" unless match

          target_type = match[1]
          :"numbers.#{number_system}.formats.currency.patterns.#{format_length_key}.#{target_type}"
        end

        def xpath_to_format_length_alias(xpath, number_system, type)
          match = xpath.match(%r{\.\./#{type}FormatLength\[@type='(\w+)'\]})
          raise "Alias doesn't match expected pattern: #{xpath}" unless match

          length = match[1]
          :"numbers.#{number_system}.formats.#{type}.patterns.#{length}"
        end

        def xpath_to_symbols_alias(xpath)
          match = xpath.match(%r{\.\./symbols\[@numberSystem='(\w+)'\]})
          raise "Alias doesn't match expected pattern: #{xpath}" unless match

          target_number_system = match[1]
          :"numbers.#{target_number_system}.symbols"
        end

        def xpath_to_format_alias(xpath, type)
          match = xpath.match(%r{\.\./#{type}Formats\[@numberSystem='(\w+)'\]})
          raise "Alias doesn't match expected pattern: #{xpath}" unless match

          target_number_system = match[1]
          :"numbers.#{target_number_system}.formats.#{type}"
        end

        def unit(number_system)
          select("numbers/currencyFormats[@numberSystem=\"#{number_system}\"]/unitPattern").each_with_object({}) do |node, result|
            count = node["count"].to_sym
            result[count] = node.content
          end
        end
      end
    end
  end
end
