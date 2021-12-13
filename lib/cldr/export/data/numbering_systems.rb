# encoding: UTF-8

module Cldr
  module Export
    module Data
      class NumberingSystems < Base

        def initialize(*args)
          super(nil)
          update(:numbering_systems => numbering_systems)
        end

        def numbering_systems
          doc.xpath("supplementalData/numberingSystems/numberingSystem").inject({}) do |ret, numbering|
            system_name = numbering.attribute("id").value
            type = numbering.attribute("type").value

            param = case type
              when "numeric"
                "digits"
              when "algorithmic"
                "rules"
            end

            ret[system_name] = {
              :type => type,
              param => numbering.attribute(param).value
            }

            ret
          end
        end
      end
    end
  end
end
