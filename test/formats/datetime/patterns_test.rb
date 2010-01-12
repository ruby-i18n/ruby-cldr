# encoding: utf-8

require File.dirname(__FILE__) + '/../../test_helper'
require 'date'

class TestCldrDatePattersFormat < Test::Unit::TestCase
  def setup
    @locale = :de
    @calendar = Cldr::Data::Calendars.new(@locale)[:calendars][:gregorian]
  end

  def format(object, pattern)
    Cldr::Format::Datetime.new(pattern, @calendar).apply(object)
  end
  
  # FULL PATTERNS

  define_method "test: full date pattern :de" do
    assert_equal 'Montag, 11. Januar 2010', format(Date.new(2010, 1, 11), 'EEEE, d. MMMM y')
  end

  define_method "test: long date pattern :de" do
    assert_equal '11. Januar 2010', format(Date.new(2010, 1, 11), 'd. MMMM y')
  end

  define_method "test: medium date pattern :de" do
    assert_equal '11.01.2010', format(Date.new(2010, 1, 11), 'dd.MM.yyyy')
  end

  define_method "test: short date pattern :de" do
    assert_equal '11.01.10', format(Date.new(2010, 1, 11), 'dd.MM.yy')
  end

  # Timezone missing
  #
  # define_method "test: full time pattern :de" do
  #   assert_equal '13:12:11 zzzz', format(Time.local(2000, 1, 1, 13, 12, 11), 'HH:mm:ss zzzz')
  # end
  
  define_method "test: long time pattern :de" do
    assert_equal '13:12:11 CET', format(Time.local(2010, 1, 1, 13, 12, 11), 'HH:mm:ss z')
  end

  define_method "test: medium time pattern :de" do
    assert_equal '13:12:11', format(Time.local(2010, 1, 1, 13, 12, 11), 'HH:mm:ss')
  end

  define_method "test: short time pattern :de" do
    assert_equal '13:12', format(Time.local(2010, 1, 1, 13, 12, 11), 'HH:mm')
  end
end