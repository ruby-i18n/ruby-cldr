# frozen_string_literal: true

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
          @subdivisions ||= select("localeDisplayNames/subdivisions/subdivision").each_with_object({}) do |node, result|
            result[node.attribute("type").value.to_sym] = node.content unless draft?(node) or alt?(node)
          end
        end
      end
    end
  end
end
