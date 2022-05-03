# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class TerritoriesContainment < Base
        def initialize(*)
          super(nil)
          update(territories: territories)
        end

        def territories
          @territories ||= doc.xpath("supplementalData/territoryContainment/group").each_with_object(
            Hash.new { |h, k| h[k] = { contains: [] } }
          ) do |territory, memo|
            territory_id = territory.attribute("type").value
            children = territory.attribute("contains").value.split(" ")

            memo[territory_id][:contains].concat(children)
            memo[territory_id][:contains].sort!
          end
        end
      end
    end
  end
end
