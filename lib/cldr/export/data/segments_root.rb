module Cldr
  module Export
    module Data
      class SegmentsRoot < Base

        def initialize
          super(nil)
          update(:segments => segmentations)
        end

        def segmentations
          doc.xpath("ldml/segmentations/segmentation").inject({}) do |ret, seg|
            type = seg.attribute("type").value
            ret[type] = segmentation(seg)
            ret
          end
        end

        def segmentation(node)
          {
            :variables => variables(node),
            :rules => rules(node)
          }
        end

        def variables(node)
          (node / "variables" / "variable").map do |variable|
            {
              :id => cast_value(variable.attribute("id").value),
              :value => variable.text
            }
          end
        end

        def rules(node)
          (node / "segmentRules" / "rule").map do |rule|
            {
              :id => cast_value(rule.attribute("id").value),
              :value => rule.text
            }
          end
        end

        def paths
          @paths ||= ["#{Cldr::Export::Data.dir}/segments/root.xml"]
        end

        def cast_value(value)
          if value =~ /\A[\d]+\z/
            value.to_i
          elsif value =~ /\A[\d.]+\z/
            value.to_f
          else
            value
          end
        end

      end
    end
  end
end
