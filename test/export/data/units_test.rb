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
    data = Cldr::Export::Data::Units.new(:de)[:units][:unit_length][:long]

    assert_operator data.keys.count, :>=, 46
    assert_equal units[:day],    data[:duration_day]
    assert_equal units[:week],   data[:duration_week]
    assert_equal units[:month],  data[:duration_month]
    assert_equal units[:year],   data[:duration_year]
    assert_equal units[:hour],   data[:duration_hour]
    assert_equal units[:minute], data[:duration_minute]
    assert_equal units[:second], data[:duration_second]
  end

  test "Alias nodes are exported as paths to their targets" do
    data = Cldr::Export::Data::Units.new(:root)
    path = data.dig(:units, :unit_length, :short, :duration_week_person)
    assert_equal :"units.unit_length.short.duration_week", path

    duration = data.dig(*split_path_string(path))
    assert_not_nil duration
  end

  private

  def split_path_string(path)
    path.to_s.split(".").map(&:to_sym)
  end
end
