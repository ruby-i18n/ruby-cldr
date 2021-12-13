module Cldr
  module Export
    module Data
      class Subdivisions < Base

        def initialize(locale)
          super
          update(subdivisions: subdivisions)
        end

        private

        def subdivisions
          @subdivisions ||= select("localeDisplayNames/subdivisions/subdivision").inject({}) do |result, node|
            result[node.attribute("type").value.to_sym] = node.content unless draft?(node) or alt?(node)
            result
          end
        end
      end
    end
  end
end
