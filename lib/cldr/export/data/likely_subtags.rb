# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class LikelySubtags < Base
        def initialize
          super(nil)
          update(subtags: subtags)
          deep_sort!
        end

        private

        def subtags
          doc.xpath("//likelySubtag").each_with_object({}) do |subtag, ret|
            from = subtag.attribute("from").value
            to = subtag.attribute("to").value
            ret[from] = to
          end
        end
      end
    end
  end
end
