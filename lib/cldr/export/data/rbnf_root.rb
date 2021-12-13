# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class RbnfRoot < Rbnf

        def initialize
          super(nil)
        end

        private

        def paths
          @paths ||= [File.join(Cldr::Export::Data.dir, "rbnf", "root.xml")]
        end

      end
    end
  end
end
