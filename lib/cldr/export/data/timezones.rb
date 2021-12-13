# I probably don't really get timezones.

module Cldr
  module Export
    module Data
      class Timezones < Base
        def initialize(locale)
          super

          update(
            formats: formats,
            timezones: timezones,
            metazones: metazones
          )
        end

        def formats
          @formats ||= select("dates/timeZoneNames/*").inject({}) do |result, format|
            if format.name.end_with?("Format")
              underscored_name = format.name.gsub(/([a-z])([A-Z])/, '\1_\2').downcase
              result[underscored_name] = format.text
            end

            result
          end
        end

        def timezones
          @timezones ||= select("dates/timeZoneNames/zone").inject({}) do |result, zone|
            type = zone.attr("type").to_sym
            result[type] = {}
            long = nodes_to_hash(zone.xpath("long/*"))
            result[type][:long] = long unless long.empty?
            short = nodes_to_hash(zone.xpath("short/*"))
            result[type][:short] = short unless short.empty?
            city = select(zone, "exemplarCity").first
            result[type][:city] = city.content if city
            result
          end
        end

        def metazones
          @metazones ||= select("dates/timeZoneNames/metazone").inject({}) do |result, zone|
            type = zone.attr("type").to_sym
            result[type] = {}
            long = nodes_to_hash(zone.xpath("long/*"))
            result[type][:long] = long unless long.empty?
            short = nodes_to_hash(zone.xpath("short/*"))
            result[type][:short] = short unless short.empty?
            result
          end
        end

        protected

        def nodes_to_hash(nodes)
          nodes.inject({}) do |result, node|
            result[node.name.to_sym] = node.content
            result
          end
        end

      end
    end
  end
end
