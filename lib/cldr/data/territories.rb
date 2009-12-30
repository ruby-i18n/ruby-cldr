module Cldr
  module Data
    class Territories < Base
      def data
        { :territories => territories }
      end

      def territories
        select('localeDisplayNames/territories/territory').inject({}) do |result, node|
          unless draft?(node)
            code = node.attribute('type').value.to_sym
            name = node.content
            result[code] = { :code => code, :name => name }
          end
          result
        end
      end
    end
  end
end