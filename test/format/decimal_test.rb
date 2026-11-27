# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../test_helper"))

class TestCldrDecimalFormat < Test::Unit::TestCase
  test "single pattern, positive number" do
    assert_equal "123", Cldr::Format::Decimal.new("#").apply(123)
  end

  test "single pattern, negative number" do
    assert_equal "-123", Cldr::Format::Decimal.new("#").apply(-123)
  end

  test "positive/negative patterns, positive number" do
    assert_equal "123", Cldr::Format::Decimal.new("#;-#").apply(123)
  end

  test "positive/negative patterns, negative number" do
    assert_equal "-123", Cldr::Format::Decimal.new("#;-#").apply(-123)
  end

  test "rounds half-even through the public formatter" do
    assert_equal "2", Cldr::Format::Decimal.new("0").apply(2.5)
    assert_equal "-2", Cldr::Format::Decimal.new("0").apply(-2.5)
    assert_equal "0.12", Cldr::Format::Decimal.new("0.00").apply(0.125)
  end

  test "formats a large integer without precision loss" do
    assert_equal "12,345,678,901,234,567,890", Cldr::Format::Decimal.new("#,##0").apply(12345678901234567890)
  end

  test "leaves a non-numeric argument untouched" do
    assert_equal "abc", Cldr::Format::Decimal.new("#").apply("abc")
  end
end
