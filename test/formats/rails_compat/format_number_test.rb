# encoding: utf-8
require File.dirname(__FILE__) + '/../../test_helper'

class TestCldrFormatRailsCompat < Test::Unit::TestCase
  def setup
    @options = { :decimal => ".", :group => ",", :format => "#,##0.###" }
  end

  def format_number(number, options = {})
    Cldr::Format.format_number(number, @options.merge(options))
  end
  
  # number_with_delimiter assertions:
  #
  # assert_equal("12,345,678", number_with_delimiter(12345678))
  # assert_equal("0", number_with_delimiter(0))
  # assert_equal("123", number_with_delimiter(123))
  # assert_equal("123,456", number_with_delimiter(123456))
  # assert_equal("123,456.78", number_with_delimiter(123456.78))
  # assert_equal("123,456.789", number_with_delimiter(123456.789))
  # assert_equal("123,456.78901", number_with_delimiter(123456.78901))
  # assert_equal("123,456,789.78901", number_with_delimiter(123456789.78901))
  # assert_equal("0.78901", number_with_delimiter(0.78901))
  # assert_equal("123,456.78", number_with_delimiter("123456.78"))
  # assert_equal("x", number_with_delimiter("x"))
  # assert_nil number_with_delimiter(nil)
  define_method :"test: NOT compatible with number_with_delimiter: 12345678 => 12,345,678.0" do
    assert_equal '12,345,678.0', format_number(12345678)
  end

  define_method :"test: NOT compatible with number_with_delimiter: 0 => 0.0" do
    assert_equal '0.0', format_number(0)
  end

  define_method :"test: NOT compatible with number_with_delimiter: 123 => 123.0" do
    assert_equal '123.0', format_number(123)
  end

  define_method :"test: NOT compatible with number_with_delimiter: 123456 => 123,456" do
    assert_equal '123,456.0', format_number(123456)
  end

  define_method :"test: compatible with number_with_delimiter: 123456.78 => 123,456.78" do
    assert_equal '123,456.78', format_number(123456.78)
  end

  define_method :"test: compatible with number_with_delimiter: 123456.789 => 123,456.789" do
    assert_equal '123,456.789', format_number(123456.789)
  end

  define_method :"test: NOT compatible with number_with_delimiter: 123456.78901 => 123,456.789" do
    assert_equal '123,456.789', format_number(123456.78901)
  end

  define_method :"test: NOT compatible with number_with_delimiter: 123456.78901 w/ precision 5 => 123,456.78901" do
    assert_equal '123,456.78901', format_number(123456.78901, :precision => 5)
  end

  define_method :"test: NOT compatible with number_with_delimiter: 123456789.78901 => 123,456,789.789" do
    assert_equal '123,456,789.789', format_number(123456789.78901)
  end

  define_method :"test: NOT compatible with number_with_delimiter: 123456789.78901 w/ precision 5 => 123,456,789.78901" do
    assert_equal '123,456,789.78901', format_number(123456789.78901, :precision => 5)
  end

  define_method :"test: NOT compatible with number_with_delimiter: 0.78901 => 0.789" do
    assert_equal '0.789', format_number(0.78901)
  end

  define_method :"test: NOT compatible with number_with_delimiter: 0.78901 w/ precision 5 => 0.78901" do
    assert_equal '0.78901', format_number(0.78901, :precision => 5)
  end

  define_method :"test: compatible with number_with_delimiter: 'x' => 'x'" do
    assert_equal 'x', format_number('x')
  end

  define_method :"test: compatible with number_with_delimiter: nil => nil" do
    assert_nil format_number(nil)
  end

  # number_with_precision assertions:
  #
  # assert_equal("111.235", number_with_precision(111.2346))
  # assert_equal("31.83", number_with_precision(31.825, :precision => 2))
  # assert_equal("111.23", number_with_precision(111.2346, :precision => 2))
  # assert_equal("111.00", number_with_precision(111, :precision => 2))
  # assert_equal("111.235", number_with_precision("111.2346"))
  # assert_equal("31.83", number_with_precision("31.825", :precision => 2))
  # assert_equal("112", number_with_precision(111.50, :precision => 0))
  # assert_equal("1234567892", number_with_precision(1234567891.50, :precision => 0))
  # assert_equal("x", number_with_precision("x"))
  # assert_nil number_with_precision(nil)
  define_method :"test: compatible with number_with_precision: 111.235 => 111.2346" do
    assert_equal "111.235", format_number(111.2346)
  end

  define_method :"test: compatible with number_with_precision: 31.825 w/ precision 2 => 31.83" do
    assert_equal "31.83",   format_number(31.825, :precision => 2)
  end

  define_method :"test: compatible with number_with_precision: 111.2346 w/ precision 2 => 111.23" do
    assert_equal "111.23",  format_number(111.2346, :precision => 2)
  end

  define_method :"test: compatible with number_with_precision: 111 w/ precision 2 => 111.00" do
    assert_equal "111.00", format_number(111, :precision => 2)
  end

  define_method :"test: compatible with number_with_precision: '111.2346' => '111.235'" do
    assert_equal "111.235", format_number("111.2346")
  end

  define_method :"test: compatible with number_with_precision: '31.825' w/ precision 2 => 31.83" do
    assert_equal "31.83", format_number("31.825", :precision => 2)
  end

  define_method :"test: compatible with number_with_precision: 111.50 w/ precision 0 => 112" do
    assert_equal "112", format_number(111.50, :precision => 0)
  end

  define_method :"test: NOT compatible with number_with_precision: 1234567891.50 w/ precision 0 => 1,234,567,892" do
    assert_equal "1,234,567,892", format_number(1234567891.50, :precision => 0)
  end

  define_method :"test: compatible with number_with_precision: 'x' => 'x'" do
    assert_equal "x", format_number("x")
  end

  define_method :"test: compatible with number_with_precision: nil => nil" do
    assert_nil format_number(nil)
  end
end