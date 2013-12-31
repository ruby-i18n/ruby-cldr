module Cldr
  module Export
    module Data
      class Numbers < Base
        def initialize(locale)
          super
          update(
            :numbers => {
              :symbols => symbols,
              :formats => {
                :decimal => {
                  :number_system => number_system('decimal'),
                  :patterns => format('decimal')
                },
                :scientific => {
                  :number_system => number_system('scientific'),
                  :patterns => format('scientific')
                },
                :percent => {
                  :number_system => number_system('percent'),
                  :patterns => format('percent')
                },
                :currency => {
                  :number_system => number_system('currency'),
                  :patterns => format('currency'),
                  :unit => unit
                }
              }
            }
          )
        end
      
        def currency
          currency = format('currency')
          currency.update(:unit => unit) unless unit.empty?
          currency
        end

        def symbols
          select('numbers/symbols/*').inject({}) do |result, node|
            result[name(node).to_sym] = node.content unless draft?(node)
            result
          end
        end

        def format(type)
          result = select("numbers/#{type}Formats/#{type}FormatLength/#{type}Format").inject({}) do |format_result, format_node|
            format_key = format_node.parent.attribute('type')
            format_result[format_key ? format_key.value : :default] = select(format_node, "pattern").inject({}) do |pattern_result, pattern_node|
              pattern_key = pattern_node.attribute('type')
              pattern_result[pattern_key ? pattern_key.value : :default] = pattern_node.content unless draft?(pattern_node)
              pattern_result
            end
            format_result
          end

          result[:default] = result[:default][:default] if result[:default]
          result
        end

        def number_system(type)
          node = select("numbers/#{type}Formats").first
          node.attribute('numberSystem').value rescue "latn"
        end

        def unit
          @unit ||= select("numbers/currencyFormats/unitPattern").inject({}) do |result, node|
            count = node.attribute('count').value rescue 'one'
            result[count] = node.content
            result
          end
        end
      end
    end
  end
end