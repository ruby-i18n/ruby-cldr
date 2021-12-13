# Ruby library for exporting and using data from CLDR

[![Tests](https://github.com/ruby-i18n/ruby-cldr/actions/workflows/test.yml/badge.svg)](https://github.com/ruby-i18n/ruby-cldr/actions/workflows/test.yml)

CLDR (["Common Locale Data Repository"](http://cldr.unicode.org)) contains tons of high-quality locale data such as formatting rules for dates, times, numbers, currencies as well as language, country, calendar-specific names etc.

For localizing applications in Ruby we'll obviously be able to use this incredibly comprehensive and well-maintained resource.

This library is a first stab at that goal. You can: 

* export CLDR data to YAML and Ruby formatted files which are supposed to be usable in an  ["I18n"](http://github.com/svenfuchs/i18n) context but might be usable elsewhere, too. 
* use CLDR compliant formatters for the following types: number, percentage, currency, date, time, datetime.

## Requirements

  * Ruby 1.9 (if you want well-ordered Hashes to be exported)
  * Thor

## Installation

```
gem install bundler
bundle install

thor cldr:download
```

## Export

The following command will export all known components from all locales to the target directory ./data/[locale]/[component].{yml,rb}:

```
$ thor cldr:export
```

You can also optionally specify locales and/or components to export as well as the target directory:

```
$ thor cldr:export --locales de fr en --components numbers plurals --target=./tmp/export
```

This will export the components :numbers and :plurals from the locales :de, :fr and :en to the same target directory.

Also note that CLDR natively builds on a locale fallback concept where all locales eventually fall back to a :root locale. E.g. the :de-AT locale only contains a single format for numbers, which means that an application is supposed to use other formats from the :de locale (fallback). Particular bits of information are only present in the :root locale where all locales fall back to eventually.

By default this library just exports data that is present in CLDR for a given locale. If you do not want to use locale fallbacks in your application you'll need to "flatten" locale fallbacks and merge the data during export time. To do that you can use the --merge option:

```
$ thor cldr:export --merge
```

## Formatters

The library includes a bunch of formatter classes that can be used to format Ruby objects like Numerics, Date, Time, DateTime etc. using the format information provided by CLDR.

E.g.:

```ruby
	options = { :decimal => ',', :group => ' ' }
	format  = Cldr::Format::Numeric.new('#,##0.##', options)
	format.apply(1234.567)
	# => "1 234,57"

	calendar = Cldr::Export::Data::Calendars.new(:de)[:calendars][:gregorian]
	format   = Cldr::Export::Format::Date.new('EEEE, d. MMMM y', calendar)
	format.apply(Date.new(2010, 1, 11))
	# => "Montag, 11. Januar 2010"

	calendar = Cldr::Export::Data::Calendars.new(:de)[:calendars][:gregorian]
	format   = Cldr::Format::Time.new('HH:mm:ss z', calendar)
	format.apply(Time.utc(2010, 1, 1, 13, 12, 11))
	# => "13:12:11 UTC"
```

In order to make these things easier to use the library provides a bunch of helpers defined in the module Cldr::Format. (This module is supposed to work as an extension to the Simple backend in the I18n gem but is included here to suggest a common API to formatters and make development easier for usecases outside of the I18n gem. If you want to include this module somewhere else you have to implement a few abstract methods to provide translations.)

E.g.:

```ruby
	format(:de, 123456.78)
	# => "123.456,78"

	format(:de, 123456.78, :as => :percent)
	# => "123.457 %"

	format(:de, 123456.78, :currency => 'EUR') 
	# => "123.456,78 EUR"

	format(:de, Date.new(2010, 1, 1), :format => :full)
	# => "Freitag, 1. Januar 2010"

	format(:de, Time.utc(2010, 1, 1, 13, 15, 17), :format => :long)
	# => "13:15:17 UTC"

	format(:de, DateTime.new(2010, 11, 12, 13, 14, 15), :format => :long)
	# => "12. November 2010 13:14:15 +00:00"

	format(:de, DateTime.new(2010, 11, 12, 13, 14, 15), :date_format => :long, :time_format => :short)
	# => "12. November 2010 13:14"
```

## Tests

```
 bundle exec ruby test/all.rb
```

## Resources

For additional information on CLDR plural rules see:

  * [http://unicode.org/draft/reports/tr35/tr35.html#Language_Plural_Rules](http://unicode.org/draft/reports/tr35/tr35.html#Language_Plural_Rules)
  * [http://www.unicode.org/cldr/export/data/charts/supplemental/language_plural_rules.html](http://www.unicode.org/cldr/export/data/charts/supplemental/language_plural_rules.html)

