# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class RbnfRoot < Rbnf
        def initialize
          super(:root)
        end
      end
    end
  end
end
