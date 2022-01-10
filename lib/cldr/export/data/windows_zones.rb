# frozen_string_literal: true

require "nokogiri"
require "time"

module Cldr
  module Export
    module Data
      class WindowsZones < Hash
        def initialize
          super

          path = "#{Cldr::Export::Data.dir}/supplemental/windowsZones.xml"
          doc = File.open(path) { |file| Nokogiri::XML(file) }
          doc.xpath("//windowsZones/mapTimezones/mapZone").each_with_object(self) do |node, result|
            zone = node.attr("other").to_s
            territory = node.attr("territory")
            timezones = node.attr("type").split(" ")
            result[zone] ||= {}
            result[zone][territory] = timezones
          end
        end
      end
    end
  end
end
