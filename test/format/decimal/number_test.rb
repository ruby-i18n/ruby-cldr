# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../../test_helper"))

class TestCldrDecimalNumberFormat < Test::Unit::TestCase
  test "interpolates a number" do
    assert_equal "123", Cldr::Format::Decimal::Number.new("###").apply(123)
  end

  test "interpolates a number on the right side" do
    assert_equal "0123", Cldr::Format::Decimal::Number.new("0###").apply(123)
  end

  test "strips optional digits" do
    assert_equal "123", Cldr::Format::Decimal::Number.new("######").apply(123)
  end

  test "single group" do
    assert_equal "1,23", Cldr::Format::Decimal::Number.new("#,##").apply(123)
  end

  test "multiple groups with a primary group size" do
    assert_equal "1,23,45,67,89", Cldr::Format::Decimal::Number.new("#,##").apply(123456789)
  end

  test "multiple groups with a primary and secondary group size" do
    assert_equal "12,34,56,789", Cldr::Format::Decimal::Number.new("#,##,##0").apply(123456789)
  end

  test "does not group when no digits left of the grouping position" do
    assert_equal "123", Cldr::Format::Decimal::Number.new("#,###").apply(123)
  end

  test "interpolates a fraction when defined by the format" do
    assert_equal "123.45", Cldr::Format::Decimal::Number.new("###.##").apply(123.45)
  end

  test "interpolates a fraction when not defined by the format but :precision given" do
    assert_equal "123.45", Cldr::Format::Decimal::Number.new("###").apply(123.45, precision: 2)
  end

  test "rounds a fraction" do
    assert_equal "123.46", Cldr::Format::Decimal::Number.new("###.##").apply(123.456)
  end

  test "interpolates fraction on the left side" do
    assert_equal "123.4500", Cldr::Format::Decimal::Number.new("###.0000#").apply(123.45)
  end

  test "rounds with precision => 0" do
    assert_equal "124", Cldr::Format::Decimal::Number.new("###.##").apply(123.55, precision: 0)
  end

  test "rounds with precision => 1" do
    assert_equal "124", Cldr::Format::Decimal::Number.new("###.##").apply(123.55, precision: 0)
  end

  test "cldr example #,##0.## => 1 234,57" do
    assert_equal "1 234,57", Cldr::Format::Decimal::Number.new("#,##0.##", decimal: ",", group: " ").apply(1234.567)
  end

  test "cldr example #,##0.### => 1 234,567" do
    assert_equal "1 234,567", Cldr::Format::Decimal::Number.new("#,##0.###", decimal: ",", group: " ").apply(1234.567)
  end

  test "cldr example ###0.##### => 1234,567" do
    assert_equal "1234,567", Cldr::Format::Decimal::Number.new("###0.#####", decimal: ",", group: " ").apply(1234.567)
  end

  test "cldr example ###0.0000# => 1234,5670" do
    assert_equal "1234,5670", Cldr::Format::Decimal::Number.new("###0.0000#", decimal: ",", group: " ").apply(1234.567)
  end

  test "cldr example 00000.0000 => 01234,5670" do
    assert_equal "01234,5670", Cldr::Format::Decimal::Number.new("00000.0000", decimal: ",", group: " ").apply(1234.567)
  end

  # CLDR / UTS #35 rounds half-even; expected values cross-checked against ICU and Babel 2.17.
  test "rounds exact halves to even at precision 2" do
    number = Cldr::Format::Decimal::Number.new("0.00")
    assert_equal "0.12", number.apply(0.125)
    assert_equal "0.62", number.apply(0.625)
    assert_equal "0.38", number.apply(0.375)
    assert_equal "0.88", number.apply(0.875)
    assert_equal "2.12", number.apply(2.125)
  end

  test "rounds exact halves to even at precision 0" do
    number = Cldr::Format::Decimal::Number.new("0")
    assert_equal "0", number.apply(0.5)
    assert_equal "2", number.apply(1.5)
    assert_equal "2", number.apply(2.5)
    assert_equal "4", number.apply(3.5)
    assert_equal "4", number.apply(4.5)
  end

  test "formats large integers without scientific notation" do
    number = Cldr::Format::Decimal::Number.new("#,##0")
    assert_equal "1,000,000,000,000,000", number.apply(10**15)
    assert_equal "10,000,000,000,000,000", number.apply(10**16)
    assert_equal "12,345,678,901,234,567,890", number.apply(12345678901234567890)
  end

  test "keeps full precision for integers above 2**53" do
    assert_equal "9,007,199,254,740,993", Cldr::Format::Decimal::Number.new("#,##0").apply(2**53 + 1)
  end
end
