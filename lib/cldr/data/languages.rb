module Cldr
  module Data
    class Languages < Base
      def data
        { :languages => languages }
      end

      def languages
        select('localeDisplayNames/languages/language').inject({}) do |result, node|
          unless draft?(node)
            code = node.attribute('type').value.gsub('_', '-').to_sym
            name = node.content
            result[code] = { :code => code, :name => name }
          end
          result
        end
      end
    end
  end
end