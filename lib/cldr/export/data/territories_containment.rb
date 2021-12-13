module Cldr
  module Export
    module Data
      class TerritoriesContainment < Base
        def initialize(*)
          super(nil)
          update(territories: territories)
        end

        def territories
          @territories ||= doc.xpath("supplementalData/territoryContainment/group").inject(
            Hash.new { |h, k| h[k] = { contains: [] } }
          ) do |memo, territory|
            territory_id = territory.attribute("type").value
            children = territory.attribute("contains").value.split(" ")

            memo[territory_id][:contains].concat(children)
            memo[territory_id][:contains].sort!

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
