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
                alternate: quotes("alternateQuotation")
              }
            }
          )
        end

        def quotes(type)
          start = select("delimiters/#{type}Start").first
          end_  = select("delimiters/#{type}End").first

          result = {}
          result[:start] = start.content if start
          result[:end]   = end_.content  if end_
          result
        end
      end
    end
  end
end
