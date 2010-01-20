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
                  :patterns => {
                    :default => format('decimal')
                  }
                },
                :scientific => {
                  :patterns => {
                    :default => format('scientific')
                  }
                },
                :percent => {
                  :patterns => {
                    :default => format('percent')
                  }
                },
                :currency => {
                  :patterns => {
                    :default => format('currency'),
                  },
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
          select("numbers/#{type}Formats/#{type}FormatLength/#{type}Format/pattern").inject({}) do |result, node|
            node.content unless draft?(node)
          end
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