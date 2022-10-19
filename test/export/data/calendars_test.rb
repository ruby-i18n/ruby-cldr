# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../../test_helper"))

class TestCldrDataCalendars < Test::Unit::TestCase
  def gregorian(options = {})
    locale = options[:locale] || :de
    Cldr::Export.data(:Calendars, locale, options)[:calendars][:gregorian]
  end

  test "calendars months :de" do
    months = {
      format: {
        abbreviated: { 1 => "Jan.", 2 => "Feb.", 3 => "März", 4 => "Apr.", 5 => "Mai", 6 => "Juni", 7 => "Juli", 8 => "Aug.", 9 => "Sept.", 10 => "Okt.", 11 => "Nov.", 12 => "Dez." },
        narrow: { 1 => "J", 2 => "F", 3 => "M", 4 => "A", 5 => "M", 6 => "J", 7 => "J", 8 => "A", 9 => "S", 10 => "O", 11 => "N", 12 => "D" },
        wide: { 1 => "Januar", 2 => "Februar", 3 => "März", 4 => "April", 5 => "Mai", 6 => "Juni", 7 => "Juli", 8 => "August", 9 => "September", 10 => "Oktober", 11 => "November", 12 => "Dezember" },
      },
      stand_alone: {
        abbreviated: { 1 => "Jan", 2 => "Feb", 3 => "Mär", 4 => "Apr", 5 => "Mai", 6 => "Jun", 7 => "Jul", 8 => "Aug", 9 => "Sep", 10 => "Okt", 11 => "Nov", 12 => "Dez" },
        narrow: { 1 => "J", 2 => "F", 3 => "M", 4 => "A", 5 => "M", 6 => "J", 7 => "J", 8 => "A", 9 => "S", 10 => "O", 11 => "N", 12 => "D" },
        wide: { 1 => "Januar", 2 => "Februar", 3 => "März", 4 => "April", 5 => "Mai", 6 => "Juni", 7 => "Juli", 8 => "August", 9 => "September", 10 => "Oktober", 11 => "November", 12 => "Dezember" },
      },
    }
    assert_equal months, gregorian[:months]
  end

  test "calendars months :en" do
    months = {
      format: {
        abbreviated: { 1 => "Jan", 2 => "Feb", 3 => "Mar", 4 => "Apr", 5 => "May", 6 => "Jun", 7 => "Jul", 8 => "Aug", 9 => "Sep", 10 => "Oct", 11 => "Nov", 12 => "Dec" },
        wide: { 1 => "January", 2 => "February", 3 => "March", 4 => "April", 5 => "May", 6 => "June", 7 => "July", 8 => "August", 9 => "September", 10 => "October", 11 => "November", 12 => "December" },
      },
      stand_alone: {
        narrow: { 1 => "J", 2 => "F", 3 => "M", 4 => "A", 5 => "M", 6 => "J", 7 => "J", 8 => "A", 9 => "S", 10 => "O", 11 => "N", 12 => "D" },
      },
    }
    assert_equal months, gregorian(locale: :en)[:months]
  end

  test "calendars months :en with merge: true" do
    months = {
      format: {
        abbreviated: { 1 => "Jan", 2 => "Feb", 3 => "Mar", 4 => "Apr", 5 => "May", 6 => "Jun", 7 => "Jul", 8 => "Aug", 9 => "Sep", 10 => "Oct", 11 => "Nov", 12 => "Dec" },
        narrow: :"calendars.gregorian.months.stand_alone.narrow",
        wide: { 1 => "January", 2 => "February", 3 => "March", 4 => "April", 5 => "May", 6 => "June", 7 => "July", 8 => "August", 9 => "September", 10 => "October", 11 => "November", 12 => "December" },
      },
      stand_alone: {
        abbreviated: :"calendars.gregorian.months.format.abbreviated",
        narrow: { 1 => "J", 2 => "F", 3 => "M", 4 => "A", 5 => "M", 6 => "J", 7 => "J", 8 => "A", 9 => "S", 10 => "O", 11 => "N", 12 => "D" },
        wide: :"calendars.gregorian.months.format.wide",
      },
    }
    assert_equal months, gregorian(locale: :en, merge: true)[:months]
  end

  test "calendars days :de" do
    days = {
      format: {
        wide: { sun: "Sonntag", mon: "Montag", tue: "Dienstag", wed: "Mittwoch", thu: "Donnerstag", fri: "Freitag", sat: "Samstag" },
        abbreviated: { sun: "So.", mon: "Mo.", tue: "Di.", wed: "Mi.", thu: "Do.", fri: "Fr.", sat: "Sa." },
        narrow: { sun: "S", mon: "M", tue: "D", wed: "M", thu: "D", fri: "F", sat: "S" },
        short: { sun: "So.", mon: "Mo.", tue: "Di.", wed: "Mi.", thu: "Do.", fri: "Fr.", sat: "Sa." },
      },
      stand_alone: {
        abbreviated: { sun: "So", mon: "Mo", tue: "Di", wed: "Mi", thu: "Do", fri: "Fr", sat: "Sa" },
        narrow: { sun: "S", mon: "M", tue: "D", wed: "M", thu: "D", fri: "F", sat: "S" },
        short: { sun: "So.", mon: "Mo.", tue: "Di.", wed: "Mi.", thu: "Do.", fri: "Fr.", sat: "Sa." },
        wide: { sun: "Sonntag", mon: "Montag", tue: "Dienstag", wed: "Mittwoch", thu: "Donnerstag", fri: "Freitag", sat: "Samstag" },
      },
    }
    assert_equal days, gregorian[:days]
  end

  test "calendars quarters :de" do
    quarters = {
      format: {
        wide: { 1 => "1. Quartal", 2 => "2. Quartal", 3 => "3. Quartal", 4 => "4. Quartal" },
        narrow: { 1 => "1", 2 => "2", 3 => "3", 4 => "4" },
        abbreviated: { 1 => "Q1", 2 => "Q2", 3 => "Q3", 4 => "Q4" },
      },
      stand_alone: {
        abbreviated: { 1 => "Q1", 2 => "Q2", 3 => "Q3", 4 => "Q4" },
        narrow: { 1 => "1", 2 => "2", 3 => "3", 4 => "4" },
        wide: { 1 => "1. Quartal", 2 => "2. Quartal", 3 => "3. Quartal", 4 => "4. Quartal" },
      },
    }
    assert_equal quarters, gregorian[:quarters]
  end

  test "calendars periods :de" do
    periods = {
      afternoon1: "mittags",
      afternoon2: "nachmittags",
      am: "AM",
      evening1: "abends",
      midnight: "Mitternacht",
      morning1: "morgens",
      morning2: "vormittags",
      night1: "nachts",
      pm: "PM",
    }
    assert_equal periods, gregorian[:periods][:format][:wide]
  end

  # root.xml
  # <eras>
  #   <eraNames>
  #     <alias source="locale" path="../eraAbbr"/>
  #   </eraNames>
  #   <eraAbbr>
  #     <era type="0">BCE</era>
  #     <era type="1">CE</era>
  #   </eraAbbr>
  #   <eraNarrow>
  #     <alias source="locale" path="../eraAbbr"/>
  #   </eraNarrow>
  # </eras>
  # test 'calendars eras :de' do
  #   eras = {
  #     0 => { :abbr => "v. Chr.", :name => "v. Chr." },
  #     1 => { :abbr => "n. Chr.", :name => "n. Chr." }
  #   }
  #   assert_equal eras, gregorian[:eras]
  # end

  test "calendars date formats :de" do
    formats = {
      full: { pattern: "EEEE, d. MMMM y" },
      long: { pattern: "d. MMMM y" },
      medium: { pattern: "dd.MM.y" },
      short: { pattern: "dd.MM.yy" },
    }
    assert_equal formats, gregorian[:formats][:date]
  end

  test "calendars time formats :de" do
    formats = {
      full: { pattern: "HH:mm:ss zzzz" },
      long: { pattern: "HH:mm:ss z" },
      medium: { pattern: "HH:mm:ss" },
      short: { pattern: "HH:mm" },
    }
    assert_equal formats, gregorian[:formats][:time]
  end

  test "calendars datetime formats :de" do
    formats = {
      full: { pattern: "{{date}} 'um' {{time}}" },
      long: { pattern: "{{date}} 'um' {{time}}" },
      medium: { pattern: "{{date}}, {{time}}" },
      short: { pattern: "{{date}}, {{time}}" },
    }
    assert_equal formats, gregorian[:formats][:datetime]
  end

  test "calendars fields :de" do
    fields = {
      day: "Tag",
      day_narrow: "Tag",
      day_short: "Tag",
      day_of_year: "Tag des Jahres",
      day_of_year_narrow: "T/J",
      day_of_year_short: "Tag des Jahres",
      day_period: "Tageshälfte",
      day_period_narrow: "Tagesh.",
      day_period_short: "Tageshälfte",
      era: "Epoche",
      era_narrow: "E",
      era_short: "Epoche",
      hour: "Stunde",
      hour_narrow: "Std.",
      hour_short: "Std.",
      minute: "Minute",
      minute_narrow: "Min.",
      minute_short: "Min.",
      month: "Monat",
      month_narrow: "M",
      month_short: "Monat",
      quarter: "Quartal",
      quarter_narrow: "Q",
      quarter_short: "Quart.",
      second: "Sekunde",
      second_narrow: "Sek.",
      second_short: "Sek.",
      week: "Woche",
      week_narrow: "W",
      week_short: "Woche",
      week_of_month: "Woche des Monats",
      week_of_month_narrow: "Wo. des Monats",
      week_of_month_short: "W/M",
      weekday: "Wochentag",
      weekday_narrow: "Wochent.",
      weekday_short: "Wochentag",
      weekday_of_month: "Wochentag",
      weekday_of_month_narrow: "WT",
      weekday_of_month_short: "Wochentag",
      year: "Jahr",
      year_narrow: "J",
      year_short: "Jahr",
      zone: "Zeitzone",
      zone_narrow: "Zeitz.",
      zone_short: "Zeitzone",
    }
    assert_equal fields, gregorian[:fields]
  end

  test "merged calendars for de-AT contains all date format and stand-alone name types" do
    assert_equal ["abbreviated", "narrow", "wide"], gregorian(merged: true)[:months][:format].keys.map(&:to_s).sort
    assert_equal ["abbreviated", "narrow", "wide"], gregorian(merged: true)[:months][:stand_alone].keys.map(&:to_s).sort
  end

  test "Gregorian eras for :root contains the expected alias nodes" do
    eras = {
      abbr: {
        0 => "BCE",
        1 => "CE",
      },
      name: :"calendars.gregorian.eras.abbr",
      narrow: :"calendars.gregorian.eras.abbr",
    }
    assert_equal eras, gregorian(locale: :root)[:eras]
  end
end
