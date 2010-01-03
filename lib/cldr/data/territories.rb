class Cldr
  module Data
    class Territories < Base
      def initialize(locale)
        super
        self[:territories] = territories
      end

      def territories
        @territories ||= select('localeDisplayNames/territories/territory').inject({}) do |result, node|
          result[node.attribute('type').value.to_sym] = node.content unless draft?(node)
          result
        end
      end
    end
  end
end