# I probably don't really get timezones.

class Cldr
  module Export
    module Data
      class Timezones < Base
        def initialize(locale)
          super
          self[:timezones] = timezones
        end

        def timezones
          @timezones ||= select('dates/timeZoneNames/zone').inject({}) do |result, zone|
            type = zone.attribute('type').value.to_sym
            city = select(zone, 'exemplarCity').first
            result[type] = {}
            # see en.xml, Europe/London, does not have an exemplarCity element
            # instead it has long and short daylight names which otherwise only
            # have metazones. (??)
            result[type][:city] = city.content if city
            result
          end
        end
      end
    end
  end
end