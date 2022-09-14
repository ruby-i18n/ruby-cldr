# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class Currencies < Base
        def initialize(locale)
          super
          update(currencies: currencies)
          deep_sort!
        end

        private

        def currencies
          select("numbers/currencies/*").each_with_object({}) do |node, result|
            currency = currency(node)
            result[node.attribute("type").value.to_sym] = currency unless currency.empty?
          end
        end

        def currency(node)
          data = select(node, "displayName").each_with_object({}) do |node, result|
            if node.attribute("count")
              count = node.attribute("count").value.to_sym
              result[count] = node.content
            else
              result[:name] = node.content
            end
          end

          symbols = select(node, "symbol")
          narrow_symbol = symbols.select { |child_node| child_node.attribute("alt")&.value == ("narrow") }.first
          data[:narrow_symbol] = narrow_symbol.content unless narrow_symbol.nil?

          symbol = symbols.select { |child_node| child_node.attribute("alt").nil? }.first
          data[:symbol] = symbol.content unless symbol.nil?

          data
        end
      end
    end
  end
end
