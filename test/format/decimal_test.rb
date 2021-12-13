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
end
