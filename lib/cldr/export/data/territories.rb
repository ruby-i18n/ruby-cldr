module Cldr
  module Export
    module Data
      class Territories < Base
        def initialize(locale)
          super
          update(:territories => territories)
        end

        def territories
          @territories ||= select('localeDisplayNames/territories/territory').inject({}) do |result, node|
            result[node.attribute('type').value.to_sym] = node.content unless draft?(node) or alt?(node)
            result
          end
        end
      end
    end
  end
end