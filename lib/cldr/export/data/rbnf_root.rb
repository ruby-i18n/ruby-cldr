module Cldr
  module Export
    module Data
      class RbnfRoot < Rbnf

        def initialize
          super(nil)
        end

        private

        def path
          @path ||= "#{Cldr::Export::Data.dir}/rbnf/root.xml"
        end

      end
    end
  end
end