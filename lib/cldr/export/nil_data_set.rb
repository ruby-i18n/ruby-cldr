# frozen_string_literal: true

require "nokogiri"

module Cldr
  module Export
    class NilDataSet
      class << self
        def [](locale)
          nil
        end

        def []=(locale, value)
          raise NotImplementedError, "tried to set a value on a NilDataSet"
        end

        def locales
          []
        end
      end
    end
  end
end
