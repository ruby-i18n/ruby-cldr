# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../../test_helper"))

class TestCldrDataUnits < Test::Unit::TestCase
  test "units" do
    units = {
      day: { one: "{0} Tag", other: "{0} Tage" },
      week: { one: "{0} Woche", other: "{0} Wochen" },
      month: { one: "{0} Monat", other: "{0} Monate" },
      year: { one: "{0} Jahr",    other: "{0} Jahre" },
      hour: { one: "{0} Stunde",  other: "{0} Stunden" },
      minute: { one: "{0} Minute",  other: "{0} Minuten" },
      second: { one: "{0} Sekunde", other: "{0} Sekunden" },
    }
    data = Cldr::Export::Data::Units.new(:de)[:units][:unitLength][:long]

    assert_operator data.keys.count, :>=, 46
    assert_equal units[:day],    data[:"duration-day"]
    assert_equal units[:week],   data[:"duration-week"]
    assert_equal units[:month],  data[:"duration-month"]
    assert_equal units[:year],   data[:"duration-year"]
    assert_equal units[:hour],   data[:"duration-hour"]
    assert_equal units[:minute], data[:"duration-minute"]
    assert_equal units[:second], data[:"duration-second"]
  end

  # Cldr::Export::Data.locales.each do |locale|
  #   test "extract units for #{locale}" do
  #     assert_nothing_raised do
  #       Cldr::Export::Data::Units.new(locale)
  #     end
  #   end
  # end
end
