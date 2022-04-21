# frozen_string_literal: true

require "nokogiri"
require "date"

module Cldr
  module Export
    module Data
      class Metazones < Hash
        def initialize
          super

          path = "#{Cldr::Export::Data.dir}/supplemental/metaZones.xml"
          doc = Cldr::Export::DataFile.parse(File.read(path))
          self[:timezones] = doc.xpath("//metaZones/metazoneInfo/timezone").each_with_object({}) do |node, result|
            timezone = node.attr("type").to_sym
            result[timezone] = metazone(node.xpath("usesMetazone"))
            result[timezone].sort_by! { |zone| [zone["from"] ? zone["from"] : DateTime.new, zone["to"] ? zone["to"] : DateTime.now] }
          end
          self[:primaryzones] = doc.xpath("//primaryZones/primaryZone").each_with_object({}) do |node, result|
            territory = node.attr("iso3166").to_sym
            result[territory] = node.content
          end
        end

        protected

        def metazone(nodes)
          nodes.each_with_object([]) do |node, result|
            mzone = node.attr("mzone")
            from = node.attr("from")
            to = node.attr("to")
            data = { "metazone" => mzone }
            data["from"] = parse_date(from) if from
            data["to"] = parse_date(to) if to
            result << data
          end
        end

        def parse_date(date)
          DateTime.strptime(date + " UTC", "%F %R %Z")
        end
      end
    end
  end
end
