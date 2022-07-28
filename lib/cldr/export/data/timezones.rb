# frozen_string_literal: true

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

        private

        def formats
          @formats ||= select("dates/timeZoneNames/*").each_with_object({}) do |format, result|
            if format.name.end_with?("Format")
              underscored_name = format.name.gsub(/([a-z])([A-Z])/, '\1_\2').downcase
              result[underscored_name] = format.text
            end
          end
        end

        def timezones
          @timezones ||= select("dates/timeZoneNames/zone").each_with_object({}) do |zone, result|
            type = zone.attr("type").to_sym
            result[type] = {}
            long = nodes_to_hash(zone.xpath("long/*"))
            result[type][:long] = long unless long.empty?
            short = nodes_to_hash(zone.xpath("short/*"))
            result[type][:short] = short unless short.empty?
            city = select_single(zone, "exemplarCity")
            result[type][:city] = city.content if city
          end
        end

        def metazones
          @metazones ||= select("dates/timeZoneNames/metazone").each_with_object({}) do |zone, result|
            type = zone.attr("type").to_sym
            result[type] = {}
            long = nodes_to_hash(zone.xpath("long/*"))
            result[type][:long] = long unless long.empty?
            short = nodes_to_hash(zone.xpath("short/*"))
            result[type][:short] = short unless short.empty?
          end
        end

        protected

        def nodes_to_hash(nodes)
          nodes.each_with_object({}) do |node, result|
            result[node.name.to_sym] = node.content
          end
        end
      end
    end
  end
end
