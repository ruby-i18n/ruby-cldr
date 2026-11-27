# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../test_helper"))

class TestCldrPercentFormat < Test::Unit::TestCase
  test "interpolates the percent sign" do
    assert_equal "12.34 %", Cldr::Format::Percent.new("0.00 %").apply(12.34)
  end

  test "rounds half-even like the decimal formatter" do
    assert_equal "0.12 %", Cldr::Format::Percent.new("0.00 %").apply(0.125)
    assert_equal "2 %", Cldr::Format::Percent.new("0 %").apply(2.5)
  end
end
