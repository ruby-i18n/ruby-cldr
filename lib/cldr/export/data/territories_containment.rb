module Cldr
  module Export
    module Data
      class TerritoriesContainment < Base
        def initialize(*)
          super(nil)
          update(:territories => territories)
        end

        def territories
          @territories ||= {}

          doc.xpath('supplementalData/territoryContainment/group').inject({}) do |memo, territory|
            territory_id = territory.attribute('type').value
            children = territory.attribute('contains').value.split(' ')

            memo[territory_id] = { :contains => children }

            memo
          end
        end

        def path
          @path ||= "#{Cldr::Export::Data.dir}/supplemental/supplementalData.xml"
        end
      end
    end
  end
end
