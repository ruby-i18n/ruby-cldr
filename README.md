# Ruby library for exporting data from CLDR

[![Tests](https://github.com/ruby-i18n/ruby-cldr/actions/workflows/test.yml/badge.svg)](https://github.com/ruby-i18n/ruby-cldr/actions/workflows/test.yml)

The Unicode Consortium's [Common Locale Data Repository (CLDR)](https://cldr.unicode.org/) contains tons of high-quality locale data such as formatting rules for dates, times, numbers, currencies as well as language, country, calendar-specific names etc.

For localizing applications in Ruby we obviously want to use this incredibly comprehensive and well-maintained resource.

`ruby-cldr` exports the [XML-serialized CLDR data](https://github.com/unicode-org/cldr/releases) as YAML and Ruby files, for consumption in an [`I18n`](https://github.com/ruby-i18n/i18n) context.

## Requirements

  * Ruby 2.6+
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

You can also optionally specify locales and/or components to export as well as the target directory:

```
thor cldr:export --locales de fr en --components numbers plurals --target=./tmp/export
```

This will export the components :numbers and :plurals from the locales `de`, `fr` and `en` to the same target directory.

### Draft level

CLDR defines a hierarchy of 4 [draft levels](http://www.unicode.org/reports/tr35/#Attribute_draft), used to indicate how confident they are in the data: `approved`, `contributed`, `provisional`, and `unconfirmed`.

By default, `ruby-cldr` only exports data from the `contributed` draft level or above (i.e., `contributed` or `approved`). This is the same threshold as is used by the [ICU](https://icu.unicode.org/) (International Components for Unicode).

Set the `--draft=` parameter to any of the 4 draft levels to have `ruby-cldr` only export data with at least that draft level (e.g., setting `--draft=provisional` will export any data with the `provisional` or above draft level (i.e., `provisional`, `contributed` and `approved`)).

```
thor cldr:export --draft=provisional
```

### Flattening

CLDR defines several mechanisms for keys to inheriting values from other keys:

* [Locale Inheritance](http://www.unicode.org/reports/tr35/#Locale_Inheritance)
* [Lateral Inheritance](http://www.unicode.org/reports/tr35/#Lateral_Inheritance)
* [Aliases](http://www.unicode.org/reports/tr35/#Alias_Elements)

Some clients will be unable to support these mechanisms, and therefore `ruby-cldr` is able to export "flattened" versions of the data to simplify the lookups.

### Locale Inheritance

All locales have an inheritance chain that eventually ends in the special `root` locale.
Data is not included in a given locale if it is present in a parent locale later in the inheritance chain.

e.g., In CLDR v41, the `en-AT` inheritance chain is defined as `en-AT` -> `en-150` -> `en` -> `root`.
Only data specific to `en-AT` will be present in the `en-AT` files. If there is data shared with other child locales of `en-AT`'s parent `en-150` (e.g., `en-DE`), then that data will be present in the `en-150` files instead of each of the children, with the understanding that the client will follow the inheritance chain to find a key if it is not found in the specific child locale.

Set the `--no-locale-inheritance` flag if your client cannot handle locale inheritance, and `ruby-cldr` will resolve all of the keys for every locale as part of the export. Note: this will result in A LOT of duplicate data being output, resulting in increased memory usage when the data is loaded.

```
thor cldr:export --no-locale-inheritance
```

### Lateral Inheritance

Set the `--no-lateral-inheritance` flag if your client cannot handle lateral inheritance, and `ruby-cldr` will resolve the keys for all combinations of CLDR-defined lateral attributes as part of the export. Note: this will result in A LOT of duplicate data being output, resulting in increased memory usage when the data is loaded.

```
thor cldr:export --no-lateral-inheritance
```

### Aliases

CLDR [Aliases](http://www.unicode.org/reports/tr35/#Alias_Elements) are exported as `Symbol`s, and `ruby-i18n/i18n`'s `I18n::Backend::Fallbacks` knows how to restart the lookup of a key when it encounters a alias/`Symbol`.

Set the `--no-aliases` flag if your client cannot handle aliases, and `ruby-cldr` will resolve the aliases as part of the export. Note: this will result in duplicate data being output, resulting in increased memory usage when the data is loaded.

```
thor cldr:export --no-aliases
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
