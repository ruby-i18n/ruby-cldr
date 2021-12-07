module Cldr
  module Export
    module Data
      class LikelySubtags < Base

        def initialize
          super(nil)
          update(:subtags => subtags)
        end

        private

        def subtags
          doc.xpath('//likelySubtag').inject({}) do |ret, subtag|
            from = subtag.attribute('from').value
            to = subtag.attribute('to').value
            ret[from] = to
            ret
          end
        end
      end
    end
  end
end
