require "nokogiri"
require "date"

module Cldr
  module Export
    module Data
      class Metazones < Hash
        def initialize
          path = "#{Cldr::Export::Data.dir}/supplemental/metaZones.xml"
          doc = File.open(path) { |file| Nokogiri::XML(file) }
          self[:timezones] = doc.xpath("//metaZones/metazoneInfo/timezone").inject({}) do |result, node|
            timezone = node.attr("type").to_sym
            result[timezone] = metazone(node.xpath("usesMetazone"))
            result[timezone].sort_by! { |zone| [zone["from"] ? zone["from"] : DateTime.new, zone["to"] ? zone["to"] : DateTime.now] }
            result
          end
          self[:primaryzones] = doc.xpath("//primaryZones/primaryZone").inject({}) do |result, node|
            territory = node.attr("iso3166").to_sym
            result[territory] = node.content
            result
          end
        end

        protected

        def metazone(nodes)
          nodes.inject([]) do |result, node|
            mzone = node.attr("mzone")
            from = node.attr("from")
            to = node.attr("to")
            data = { "metazone" => mzone }
            data["from"] = parse_date(from) if from
            data["to"] = parse_date(to) if to
            result << data
            result
          end
        end

        def parse_date(date)
          DateTime.strptime(date + " UTC", "%F %R %Z")
        end
      end
    end
  end
end
