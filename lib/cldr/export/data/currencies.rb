# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class Currencies < Base
        def initialize(locale)
          super
          update(currencies: currencies)
        end

        def currencies
          select("numbers/currencies/*").each_with_object({}) do |node, result|
            currency = self.currency(node)
            result[node.attribute("type").value.to_sym] = currency unless currency.empty?
          end
        end

        def currency(node)
          data = select(node, "displayName").each_with_object({}) do |node, result|
            unless draft?(node)
              if node.attribute("count")
                count = node.attribute("count").value.to_sym
                result[count] = node.content
              else
                result[:name] = node.content
              end
            end
          end

          symbol = select(node, "symbol")
          narrow_symbol = symbol.select { |child_node| child_node.values.include?("narrow") }.first
          data[:symbol] = symbol.first.content unless symbol.empty?
          data[:narrow_symbol] = narrow_symbol.content unless narrow_symbol.nil?

          data
        end
      end
    end
  end
end
