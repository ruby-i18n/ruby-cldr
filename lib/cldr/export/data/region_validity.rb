# frozen_string_literal: true

module Cldr
  module Export
    module Data
      class RegionValidity < Base
        def initialize
          super(nil)
          update(validity: { regions: regions })
          deep_sort!
        end

        private

        def regions
          doc.xpath("/supplementalData/idValidity/id[@type='region']").each_with_object({}) do |node, hash|
            type = node.attribute("idStatus").to_s.to_sym
            hash[type] = node.content.split(/\s+/).map(&:strip).reject(&:empty?).flat_map { |element| expand_range(*element.split("~")) }
          end
        end

        def expand_range(start, endd = nil)
          return [start] if endd.nil?

          prefix = start[0...-1]
          ((start[-1].ord)..(endd.ord)).map(&:chr).map { |c| "#{prefix}#{c}" }
        end
      end
    end
  end
end
