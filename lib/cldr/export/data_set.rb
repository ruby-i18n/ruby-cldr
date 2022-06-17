# frozen_string_literal: true

require_relative "nil_data_set"

module Cldr
  module Export
    class DataSet
      def initialize(parent: nil)
        @file_cache = {}
        @parent = parent || NilDataSet
      end

      def [](locale)
        file_cache[locale] ||= compute(locale)
      end

      def []=(locale, value)
        file_cache[locale] = value
      end

      def locales
        (file_cache.keys + locales_at_this_level + (parent&.locales || [])).uniq.sort
      end

      private

      attr_reader :file_cache, :parent

      def locales_at_this_level
        file_cache.keys
      end

      def compute(locale)
        parent[locale]
      end
    end
  end
end
