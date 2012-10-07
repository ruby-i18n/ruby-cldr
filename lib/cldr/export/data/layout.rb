module Cldr
  module Export
    module Data
      class Layout < Base
        def initialize(locale)
          super
          update(:layout => layout)
        end

        def layout
          select('layout').inject({}) do |result, node|
            result['orientation'] = select(node, 'orientation').inject({}) do |orient_result, orient_node|
              if orient_node.attribute('characters')
                orient_result['characters'] = orient_node.attribute('characters').value
              end
              orient_result
            end
            result
          end
        end
      end
    end
  end
end