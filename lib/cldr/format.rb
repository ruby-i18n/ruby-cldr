# encoding: utf-8
require 'core_ext/string/camelize'

class Cldr
  module Format
    autoload :Base,     'cldr/format/base'
    autoload :Currency, 'cldr/format/currency'
    autoload :Fraction, 'cldr/format/fraction'
    autoload :Integer,  'cldr/format/integer'
    autoload :Date,     'cldr/format/date'
    autoload :Datetime, 'cldr/format/datetime'
    autoload :Decimal,  'cldr/format/decimal'
    autoload :Numeric,  'cldr/format/numeric'
    autoload :Percent,  'cldr/format/percent'
    autoload :Time,     'cldr/format/time'
  end
end