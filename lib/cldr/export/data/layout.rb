# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class Layout < Base
        def initialize(locale)
          super
          update(layout: layout)
        end

        def layout
          result = { orientation: { character_order: nil } }

          if node = select("layout/orientation/characterOrder/text()").first
            result[:orientation][:character_order] = node.text
          end

          result
        end
      end
    end
  end
end