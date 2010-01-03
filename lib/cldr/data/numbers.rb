class Cldr
  module Data
    class Numbers < Base
      def initialize(locale)
        super
        self[:'numbers.symbols'] = symbols
        self[:'numbers.formats.decimal']    = format('decimal')
        self[:'numbers.formats.scientific'] = format('scientific')
        self[:'numbers.formats.percent']    = format('percent')
        self[:'numbers.formats.currency']   = currency
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
          result[name(node).to_sym] = node.content unless draft?(node)
          result
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