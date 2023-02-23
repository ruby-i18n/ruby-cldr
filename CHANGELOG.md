# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## How do I make a good changelog?
### Guiding Principles
- Changelogs are for humans, not machines.
- There should be an entry for every single version.
- The same types of changes should be grouped.
- Versions and sections should be linkable.
- The latest version comes first.
- The release date of each version is displayed.
- Mention whether you follow Semantic Versioning.

### Types of changes
- Added for new features.
- Changed for changes in existing functionality.
- Deprecated for soon-to-be removed features.
- Removed for now removed features.
- Fixed for any bug fixes.
- Security in case of vulnerabilities.

## [Unreleased]

- Only export plurals.rb for those that have plurals data, [#71](https://github.com/ruby-i18n/ruby-cldr/pull/71)
- Only export plural keys for currencies that have pluralization data, [#80](https://github.com/ruby-i18n/ruby-cldr/pull/80)
- Sort the exported data by key, [#82](https://github.com/ruby-i18n/ruby-cldr/pull/82)
- Prune empty hashes / files before outputting, [#86](https://github.com/ruby-i18n/ruby-cldr/pull/86)
- Re-add the `ParentLocales` component, this time as a shared component, [#91](https://github.com/ruby-i18n/ruby-cldr/pull/91)
- Changed the keys and values of `ParentLocales` component to be symbols, [#101](https://github.com/ruby-i18n/ruby-cldr/pull/101)
- Fixed bug with fallbacks for locales that had more than two segments, [#101](https://github.com/ruby-i18n/ruby-cldr/pull/101)
- Merge all the related data files before doing lookups, [#98](https://github.com/ruby-i18n/ruby-cldr/pull/98)
- Standardize component names for the `thor cldr:export` command (and internally in the codebase), [#121](https://github.com/ruby-i18n/ruby-cldr/pull/121)
- Standardize locale names for the `thor cldr:export` command (and internally in the codebase), [#121](https://github.com/ruby-i18n/ruby-cldr/pull/121)
- Output `plurals.rb` with the `ruby-cldr` style locale codes (only affects `pt-PT` in CLDR v34), [#121](https://github.com/ruby-i18n/ruby-cldr/pull/121)
- Export data at with a consistent minimum draft status, [#124](https://github.com/ruby-i18n/ruby-cldr/pull/124)
- Add `--draft-status` flag for specifying the minimum draft status for data to be exported, [#124](https://github.com/ruby-i18n/ruby-cldr/pull/124)
- Export locale-specific data files into `locales` subdirectory, [#135](https://github.com/ruby-i18n/ruby-cldr/pull/135)
- Inherit currency symbol from ancestor locale instead of using other versions, [#137](https://github.com/ruby-i18n/ruby-cldr/pull/137)
- Export region validity data, [#179](https://github.com/ruby-i18n/ruby-cldr/pull/179)
- `Layout` component no longer exports files unless they contain data, [#183](https://github.com/ruby-i18n/ruby-cldr/pull/183)
- Sort the data at the component level, allowing components to specify their own sort orders, [#200](https://github.com/ruby-i18n/ruby-cldr/pull/200)
- Export `<contextTransforms>` data, [#206](https://github.com/ruby-i18n/ruby-cldr/pull/206)
- `Numbers` component now outputs data from all number systems, [#189](https://github.com/ruby-i18n/ruby-cldr/pull/189)
- Use `snake_case` for key names unless they are an external identifier, [#207](https://github.com/ruby-i18n/ruby-cldr/pull/207)
- Add `WeekData` component, [#229](https://github.com/ruby-i18n/ruby-cldr/pull/229)

---

## [0.5.0] - 2020-11-20

- Added a changelog, [#49](https://github.com/ruby-i18n/ruby-cldr/pull/49)
- Added Travis CI for testing, [#48](https://github.com/ruby-i18n/ruby-cldr/pull/48)
- Added root fallback to en language, [#47](https://github.com/ruby-i18n/ruby-cldr/pull/47)
- Added subdivisions to the list of exportable components, [#46](https://github.com/ruby-i18n/ruby-cldr/pull/46)
- Added country codes as an exportable component, [#61](https://github.com/ruby-i18n/ruby-cldr/pull/61)
- Added narrow symbols to exported currency data, [#64](https://github.com/ruby-i18n/ruby-cldr/pull/64)

## [0.4.0] - 2020-09-01

- Support pluralization codes with missing spaces [#53](https://github.com/ruby-i18n/ruby-cldr/pull/53)
- Add in functionality to export country codes [#61](https://github.com/ruby-i18n/ruby-cldr/pull/61)

## [0.3.0] - 2019-06-16

- Export currency names [#51](https://github.com/ruby-i18n/ruby-cldr/pull/51)
- Bring back root fallback for english [#47](https://github.com/ruby-i18n/ruby-cldr/pull/47)
- Export subdivisions [#46](https://github.com/ruby-i18n/ruby-cldr/pull/46)

## [0.2.0] - 2019-03-26

- Updated to CLDR 34 [#43](https://github.com/ruby-i18n/ruby-cldr/pull/43)
- Lots of [other changes](https://github.com/ruby-i18n/ruby-cldr/compare/v0.1.1...v0.2.0)

[Unreleased]: https://github.com/ruby-i18n/ruby-cldr/compare/v0.5.0...HEAD
