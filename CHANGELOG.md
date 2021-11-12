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
