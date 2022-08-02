# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class Delimiters < Base
        def initialize(locale)
          super
          update(
            delimiters: {
              quotes: {
                default: quotes("quotation"),
                alternate: quotes("alternateQuotation"),
              },
            }
          )
        end

        private

        def quotes(type)
          start = select_single("delimiters/#{type}Start")
          end_  = select_single("delimiters/#{type}End")

          result = {}
          result[:start] = start.content if start
          result[:end]   = end_.content  if end_
          result
        end
      end
    end
  end
end
