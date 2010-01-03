module Cldr
  module Data
    class Languages < Base
      def initialize(locale)
        super
        self[:languages] = languages
      end

      def languages
        @languages ||= select('localeDisplayNames/languages/language').inject({}) do |result, node|
          result[node.attribute('type').value.gsub('_', '-').to_sym] = node.content unless draft?(node)
          result
        end
      end
    end
  end
end