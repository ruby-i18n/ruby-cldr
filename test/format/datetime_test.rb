# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__) + '/../test_helper'))
require 'date'

class TestCldrDatetimeFormat < Test::Unit::TestCase
  def setup
    @locale = :de
    @calendar = Cldr::Export::Data::Calendars.new(@locale)[:calendars][:gregorian]
  end

  test "datetime pattern :de" do
    date   = Cldr::Format::Date.new('dd.MM.yyyy', @calendar)
    time   = Cldr::Format::Time.new('HH:mm', @calendar)
    result = Cldr::Format::Datetime.new('{{date}} {{time}}', date, time).apply(DateTime.new(2010, 1, 10, 13, 12, 11))
    assert_equal '10.01.2010 13:12', result
  end
end