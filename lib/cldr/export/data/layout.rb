# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class Layout < Base
        def initialize(locale)
          super
          update(layout: layout)
        end

        private

        def layout
          result = { orientation: {} }

          if (node = select_single("layout/orientation/characterOrder/text()"))
            result[:orientation][:character_order] = node.text
          end

          result
        end
      end
    end
  end
end
