# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../../test_helper"))

class TestCldrDataWeekData < Test::Unit::TestCase
  test "first day data" do
    first_day = Cldr::Export::Data::WeekData.new[:first_day]
    assert_equal(["MV"], first_day["fri"])
  end
end
