# Ruby library for exporting data from CLDR

[![Tests](https://github.com/ruby-i18n/ruby-cldr/actions/workflows/test.yml/badge.svg)](https://github.com/ruby-i18n/ruby-cldr/actions/workflows/test.yml)

The Unicode Consortium's [Common Locale Data Repository (CLDR)](https://cldr.unicode.org/) contains tons of high-quality locale data such as formatting rules for dates, times, numbers, currencies as well as language, country, calendar-specific names etc.

For localizing applications in Ruby we obviously want to use this incredibly comprehensive and well-maintained resource.

`ruby-cldr` exports the [XML-serialized CLDR data](https://github.com/unicode-org/cldr/releases) as YAML and Ruby files, for consumption in an [`I18n`](https://github.com/ruby-i18n/i18n) context.

## WIP status

`ruby-cldr` is a work in progress towards a complete and accurate serialization of the CLDR data as Ruby + YAML files.

There are still a number of issues that need to be addressed before it can be considered production-ready.

## Requirements

  * Ruby 2.7+
  * [Thor](http://whatisthor.com/)

## Installation

```
gem install bundler
bundle install

thor cldr:download
```

## Export

By default, the `thor cldr:export` command will export all known components from all locales to the target directory:

```
thor cldr:export
```

### Locales, components, and target directory

You can also optionally specify locales and/or components to export as well as the target directory:

```bash
# Export the `Numbers` and `Plurals` components for the locales `de`, `fr-FR` and `en-ZA` to the `./data` target directory

thor cldr:export --locales de fr-FR en-ZA --components Numbers Plurals --target=./data

```

### Draft status

CLDR defines a hierarchy of four [draft statuses](http://www.unicode.org/reports/tr35/#Attribute_draft), used to indicate how confident they are in the data: `unconfirmed` < `provisional` < `contributed` < `approved`.

By default, `ruby-cldr` only exports data with a minimum draft status of `contributed` (i.e., `contributed` or `approved`). This is the same threshold that is used by the Unicode Consortium's [International Components for Unicode (ICU)](https://icu.unicode.org/).

Set the `--draft-status=` parameter to specify the minimum draft status the data needs in order to be exported:

```bash
# Export any data with a minimum draft status of `provisional`
# (i.e., `provisional`, `contributed` or `approved`)).

thor cldr:export --draft-status=provisional
```

## Tests

```
bundle exec ruby test/all.rb
```

## Resources

* [`unicode-org/cldr`](https://github.com/unicode-org/cldr), the official upstream source of CLDR data
* [`unicode-org/cldr-json`](https://github.com/unicode-org/cldr-json/), a JSON serialization of the CLDR data
* [CLDR Markup specification](http://www.unicode.org/reports/tr35/)
* [Plural Rules table](https://unicode-org.github.io/cldr-staging/charts/41/supplemental/language_plural_rules.html)
