# encoding: utf-8
require File.dirname(__FILE__) + '/../../test_helper'

class TestCldrFormatIntegerRailsCompat < Test::Unit::TestCase
  def setup
    @options = { :decimal => ".", :group => ",", :format => "#,##0.###" }
  end

  def format_integer(number, options = {})
    Cldr::Format.format_integer(number, @options.merge(options))
  end
  
  define_method :"test: compatible with number_with_delimiter: 12345678 => 12,345,678" do
    assert_equal '12,345,678', format_integer(12345678)
  end

  define_method :"test: compatible with number_with_delimiter: 0 => 0" do
    assert_equal '0', format_integer(0)
  end

  define_method :"test: compatible with number_with_delimiter: 123 => 123" do
    assert_equal '123', format_integer(123)
  end

  define_method :"test: compatible with number_with_delimiter: 123456 => 123,456" do
    assert_equal '123,456', format_integer(123456)
  end

  define_method :"test: NOT compatible with number_with_delimiter: 123456.78 => 123,457" do
    assert_equal '123,457', format_integer(123456.78)
  end

  define_method :"test: NOT compatible with number_with_delimiter: 123456.789 => 123,457" do
    assert_equal '123,457', format_integer(123456.789)
  end

  define_method :"test: NOT compatible with number_with_delimiter: 123456.78901 => 123,457" do
    assert_equal '123,457', format_integer(123456.78901)
  end

  define_method :"test: NOT compatible with number_with_delimiter: 123456789.78901 => 123,456,790" do
    assert_equal '123,456,790', format_integer(123456789.78901)
  end

  define_method :"test: NOT compatible with number_with_delimiter: 0.78901 => 0" do
    assert_equal '1', format_integer(0.78901)
  end

  define_method :"test: compatible with number_with_delimiter: 'x' => 'x'" do
    assert_equal 'x', format_integer('x')
  end

  define_method :"test: compatible with number_with_delimiter: nil => nil" do
    assert_nil format_integer(nil)
  end
end