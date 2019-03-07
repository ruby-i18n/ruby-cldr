require 'nokogiri'

module Cldr
  module Export
    module Data
      class ParentLocales < Hash
        def initialize(_)
          path = File.join(Cldr::Export::Data.dir, 'supplemental', 'supplementalData.xml')
          doc = File.open(path) { |file| Nokogiri::XML(file) }

          doc.xpath('//parentLocales/parentLocale').each do |node|
            parent = node.attr('parent')
            locales = node.attr('locales').split(' ')

            locales.each do |locale|
              self[locale] = parent
            end
          end
        end
      end
    end
  end
end
