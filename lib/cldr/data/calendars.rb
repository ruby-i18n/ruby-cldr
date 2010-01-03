module Cldr
  module Data
    class Calendars < Base
      autoload :Gregorian, 'cldr/data/calendars/gregorian'

      def initialize(locale)
        super
        self['calendars.gregorian'] = Gregorian.new(locale)
      end
    end
  end
end