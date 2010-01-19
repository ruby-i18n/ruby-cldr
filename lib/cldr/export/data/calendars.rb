class Cldr
  module Export
    module Data
      class Calendars < Base
        autoload :Gregorian, 'cldr/export/data/calendars/gregorian'

        def initialize(locale)
          super
          self['calendars.gregorian'] = Gregorian.new(locale)
        end
      end
    end
  end
end