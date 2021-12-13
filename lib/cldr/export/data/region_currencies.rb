module Cldr
  module Export
    module Data
      class RegionCurrencies < Base

        def initialize
          super(nil)
          update(:region_currencies => currencies)
        end

        private

        def currencies
          doc.xpath('//currencyData/region').inject({}) do |ret, region|
            name = region.attribute('iso3166').value
            ret[name] = currency(region)
            ret
          end
        end

        def currency(node)
          (node / 'currency').map do |currency|
            currency_code = currency.attribute('iso4217').value
            result = { currency: currency_code }

            if from_node = currency.attribute('from')
              result[:from] = from_node.value
            end

            if to_node = currency.attribute('to')
              result[:to] = to_node.value
            end

            result
          end
        end
      end
    end
  end
end
