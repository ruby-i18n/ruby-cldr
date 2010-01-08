# encoding: utf-8
require File.dirname(__FILE__) + '/../test_helper'

class TestCldrFormat < Test::Unit::TestCase
  include Cldr::Format

  def setup
    @locale = :de
  end

  def t(key)
    keys = key.to_s.split('.')
    data = Cldr::Data::Numbers.new(@locale)[keys.shift.to_sym]
    keys.inject(data) { |data, key| data[key.to_sym] }
  end

  define_method :"test: format_number applies a cldr number format to an integer" do
    format  = t(:'numbers.formats.decimal.pattern')
    symbols = t(:'numbers.symbols')
    options = symbols.merge(:format => format)

    assert_equal '1.000', format_number(1000, options)
  end

  define_method :"test: format_number applies a cldr number format to a float" do
    format  = t(:'numbers.formats.decimal.pattern')
    symbols = t(:'numbers.symbols')
    options = symbols.merge(:format => format)

    assert_equal '1.000,0', format_number(1000.0, options)
  end

  define_method :"test: format_currency applies a cldr number format to a float" do
    format   = t(:'numbers.formats.currency.pattern')
    symbols  = t(:'numbers.symbols')
    currency = 'EUR'
    options  = symbols.merge(:format => format, :currency => currency)

    assert_equal '1.000,00 EUR', format_currency(1000.0, options)
  end

  define_method :"test: format_number rails compat" do
    @locale = :en
    format  = t(:'numbers.formats.decimal.pattern')
    options = t(:'numbers.symbols').merge(:format => format)

    assert_equal '12,345,678',        format_number(12345678, options)
    assert_equal '0',                 format_number(0, options)
    assert_equal '123',               format_number(123, options)
    assert_equal '123,456',           format_number(123456, options)
    assert_equal '123,456.78',        format_number(123456.78, options)
    assert_equal '123,456.789',       format_number(123456.789, options)
    assert_equal '123,456.789',       format_number(123456.78901, options)
    assert_equal '123,456.78901',     format_number(123456.78901, options.merge(:format => "#,##0.######"))
    assert_equal '123,456.78901',     format_number(123456.78901, options.merge(:precision => 5))
    assert_equal '123,456,789.789',   format_number(123456789.78901, options)
    assert_equal '123,456,789.78901', format_number(123456789.78901, options.merge(:format => "#,##0.######"))
    assert_equal '123,456,789.78901', format_number(123456789.78901, options.merge(:precision => 5))
    assert_equal '0.78901',           format_number(0.78901, options.merge(:format => "#,##0.######"))
    assert_equal 'x',                 format_number('x', options)
    assert_nil                        format_number(nil, options)
  end

  # RAILS - from template/number_helper_test.rb
  #
  # # number_with_delimiter
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
  #
  # # number_with_precision
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
end