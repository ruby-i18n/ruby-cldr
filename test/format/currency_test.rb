# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../test_helper"))

class TestCldrCurrencyFormat < Test::Unit::TestCase
  test "interpolates the currency symbol" do
    assert_equal "$123.45", Cldr::Format::Currency.new("¤0.00").apply(123.45, currency: "$")
  end

  test "rounds half-even like the decimal formatter" do
    assert_equal "$0.12", Cldr::Format::Currency.new("¤0.00").apply(0.125, currency: "$")
    assert_equal "$2", Cldr::Format::Currency.new("¤0").apply(2.5, currency: "$")
  end

  test "formats a large amount without scientific notation" do
    assert_equal "$12,345,678,901,234,567,890", Cldr::Format::Currency.new("¤#,##0").apply(12345678901234567890, currency: "$")
  end
end
