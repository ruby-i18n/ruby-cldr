# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class WeekData < Base
        def initialize(*)
          super(nil)
          update(first_day: first_day)
          deep_sort!
        end

        def first_day
          @week_data ||= doc.xpath("supplementalData/weekData/firstDay").filter_map do |node|
            alt = node.attribute("alt")
            next if alt

            day = node.attribute("day").value
            territories = node.attribute("territories").value.split(" ")
            [day, territories]
          end.to_h
        end
      end
    end
  end
end
