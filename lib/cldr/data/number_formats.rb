module Cldr
  module Data
    class NumberFormats < Base
      def data
        {
          :numbers => {
            :formats => {
              :decimal    => format('decimal'),
              :scientific => format('scientific'),
              :percent    => format('percent'),
              :currency   => format('currency').merge(currency_unit)
            }
          }
        }
      end

      def format(type)
        select("numbers/#{type}Formats/#{type}FormatLength/#{type}Format/pattern").inject({}) do |result, node|
          result[name(node).to_sym] = node.content unless draft?(node)
          result
        end
      end

      def currency_unit
        select("numbers/currencyFormats/unitPattern").inject({ :unit => {} }) do |result, node|
          count = node.attribute('count').value rescue 'one'
          result[:unit][count] = node.content
          result
        end
      end
    end
  end
end