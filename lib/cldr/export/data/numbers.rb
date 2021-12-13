# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class Numbers < Base
        def initialize(locale)
          super
          update(
            numbers: {
              symbols: symbols,
              formats: {
                decimal: {
                  number_system: number_system("decimal"),
                  patterns: format("decimal")
                },
                scientific: {
                  number_system: number_system("scientific"),
                  patterns: format("scientific")
                },
                percent: {
                  number_system: number_system("percent"),
                  patterns: format("percent")
                },
                currency: {
                  number_system: number_system("currency"),
                  patterns: format("currency"),
                  unit: unit
                }
              }
            }
          )
        end

        def currency
          currency = format("currency")
          currency.update(unit: unit) unless unit.empty?
          currency
        end

        def symbols
          select("numbers/symbols/*").inject({}) do |result, node|
            result[name(node).to_sym] = node.content unless draft?(node)
            result
          end
        end

        def format(type)
          result = select("numbers/#{type}Formats/#{type}FormatLength").inject({}) do |format_result, format_length_node|
            format_nodes = select(format_length_node, "#{type}Format")

            format_key = format_length_node.attribute("type")
            format_key = format_key ? format_key.value : :default

            if format_nodes.size > 0
              format_nodes.each do |format_node|
                format_result[format_key] ||= select(format_node, "pattern").inject({}) do |pattern_result, pattern_node|
                  pattern_key_node = pattern_node.attribute("type")

                  pattern_count_node = pattern_node.attribute("count")

                  unless draft?(pattern_node)
                    pattern_key = pattern_key_node ? pattern_key_node.value : :default

                    if pattern_count_node
                      pattern_count = pattern_count_node.value

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

                  pattern_result
                end
              end
            else
              aliased = select(format_length_node, "alias").first

              if aliased
                format_result[format_key] = xpath_to_redirect(aliased.attribute("path").value)
              end
            end

            format_result
          end

          result[:default] = result[:default][:default] if result[:default]
          result
        end

        def xpath_to_redirect(xpath)
          length = xpath[/(\w+)FormatLength/, 1]
          type   = xpath[/@type='(\w+)'/, 1]

          :"numbers.formats.#{length}.patterns.#{type}"
        end

        def number_system(type)
          node = select("numbers/#{type}Formats").first
          node.attribute("numberSystem").value rescue "latn"
        end

        def unit
          @unit ||= select("numbers/currencyFormats/unitPattern").inject({}) do |result, node|
            count = node.attribute("count").value
            result[count] = node.content
            result
          end
        end
      end
    end
  end
end