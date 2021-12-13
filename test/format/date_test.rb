# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../test_helper"))
require "date"

class TestCldrDateFormat < Test::Unit::TestCase
  def setup
    @locale = :de
    @calendar = Cldr::Export::Data::Calendars.new(@locale)[:calendars][:gregorian]
  end

  def format(object, pattern)
    Cldr::Format::Date.new(pattern, @calendar).apply(object)
  end
  
  test "full date pattern :de" do
    assert_equal "Montag, 11. Januar 2010", format(Date.new(2010, 1, 11), "EEEE, d. MMMM y")
  end
  
  # FORMATS

  test "long date pattern :de" do
    assert_equal "11. Januar 2010", format(Date.new(2010, 1, 11), "d. MMMM y")
  end

  test "medium date pattern :de" do
    assert_equal "11.01.2010", format(Date.new(2010, 1, 11), "dd.MM.yyyy")
  end

  test "short date pattern :de" do
    assert_equal "11.01.10", format(Date.new(2010, 1, 11), "dd.MM.yy")
  end
  
  # YEAR

  test "pattern y" do
    assert_equal     "5", format(Date.new(    5, 1, 1), "y")
    assert_equal    "45", format(Date.new(   45, 1, 1), "y")
    assert_equal   "345", format(Date.new(  345, 1, 1), "y")
    assert_equal  "2345", format(Date.new( 2345, 1, 1), "y")
    assert_equal "12345", format(Date.new(12345, 1, 1), "y")
  end

  test "pattern yy" do
    assert_equal    "05", format(Date.new(    5, 1, 1), "yy")
    assert_equal    "45", format(Date.new(   45, 1, 1), "yy")
    assert_equal    "45", format(Date.new(  345, 1, 1), "yy")
    assert_equal    "45", format(Date.new( 2345, 1, 1), "yy")
    assert_equal    "45", format(Date.new(12345, 1, 1), "yy")
  end

  test "pattern yyy" do
    assert_equal   "005", format(Date.new(    5, 1, 1), "yyy")
    assert_equal   "045", format(Date.new(   45, 1, 1), "yyy")
    assert_equal   "345", format(Date.new(  345, 1, 1), "yyy")
    assert_equal  "2345", format(Date.new( 2345, 1, 1), "yyy")
    assert_equal "12345", format(Date.new(12345, 1, 1), "yyy")
  end

  test "pattern yyyy" do
    assert_equal  "0005", format(Date.new(    5, 1, 1), "yyyy")
    assert_equal  "0045", format(Date.new(   45, 1, 1), "yyyy")
    assert_equal  "0345", format(Date.new(  345, 1, 1), "yyyy")
    assert_equal  "2345", format(Date.new( 2345, 1, 1), "yyyy")
    assert_equal "12345", format(Date.new(12345, 1, 1), "yyyy")
  end

  test "pattern yyyyy" do
    assert_equal "00005", format(Date.new(    5, 1, 1), "yyyyy")
    assert_equal "00045", format(Date.new(   45, 1, 1), "yyyyy")
    assert_equal "00345", format(Date.new(  345, 1, 1), "yyyyy")
    assert_equal "02345", format(Date.new( 2345, 1, 1), "yyyyy")
    assert_equal "12345", format(Date.new(12345, 1, 1), "yyyyy")
  end

  # QUARTER

  test "pattern Q" do
    assert_equal "1", format(Date.new(2010, 1,  1),  "Q")
    assert_equal "1", format(Date.new(2010, 3, 31),  "Q")
    assert_equal "2", format(Date.new(2010, 4,  1),  "Q")
    assert_equal "2", format(Date.new(2010, 6, 30),  "Q")
    assert_equal "3", format(Date.new(2010, 7,  1),  "Q")
    assert_equal "3", format(Date.new(2010, 9, 30),  "Q")
    assert_equal "4", format(Date.new(2010, 10,  1), "Q")
    assert_equal "4", format(Date.new(2010, 12, 31), "Q")
  end

  test "pattern QQ" do
    assert_equal "01", format(Date.new(2010, 1,  1),  "QQ")
    assert_equal "01", format(Date.new(2010, 3, 31),  "QQ")
    assert_equal "02", format(Date.new(2010, 4,  1),  "QQ")
    assert_equal "02", format(Date.new(2010, 6, 30),  "QQ")
    assert_equal "03", format(Date.new(2010, 7,  1),  "QQ")
    assert_equal "03", format(Date.new(2010, 9, 30),  "QQ")
    assert_equal "04", format(Date.new(2010, 10,  1), "QQ")
    assert_equal "04", format(Date.new(2010, 12, 31), "QQ")
  end

  test "pattern QQQ" do
    assert_equal "Q1", format(Date.new(2010, 1,  1),  "QQQ")
    assert_equal "Q1", format(Date.new(2010, 3, 31),  "QQQ")
    assert_equal "Q2", format(Date.new(2010, 4,  1),  "QQQ")
    assert_equal "Q2", format(Date.new(2010, 6, 30),  "QQQ")
    assert_equal "Q3", format(Date.new(2010, 7,  1),  "QQQ")
    assert_equal "Q3", format(Date.new(2010, 9, 30),  "QQQ")
    assert_equal "Q4", format(Date.new(2010, 10,  1), "QQQ")
    assert_equal "Q4", format(Date.new(2010, 12, 31), "QQQ")
  end

  test "pattern QQQQ" do
    assert_equal "1. Quartal", format(Date.new(2010, 1,  1),  "QQQQ")
    assert_equal "1. Quartal", format(Date.new(2010, 3, 31),  "QQQQ")
    assert_equal "2. Quartal", format(Date.new(2010, 4,  1),  "QQQQ")
    assert_equal "2. Quartal", format(Date.new(2010, 6, 30),  "QQQQ")
    assert_equal "3. Quartal", format(Date.new(2010, 7,  1),  "QQQQ")
    assert_equal "3. Quartal", format(Date.new(2010, 9, 30),  "QQQQ")
    assert_equal "4. Quartal", format(Date.new(2010, 10,  1), "QQQQ")
    assert_equal "4. Quartal", format(Date.new(2010, 12, 31), "QQQQ")
  end

  test "pattern q" do
    assert_equal "1", format(Date.new(2010, 1,  1),  "q")
    assert_equal "1", format(Date.new(2010, 3, 31),  "q")
    assert_equal "2", format(Date.new(2010, 4,  1),  "q")
    assert_equal "2", format(Date.new(2010, 6, 30),  "q")
    assert_equal "3", format(Date.new(2010, 7,  1),  "q")
    assert_equal "3", format(Date.new(2010, 9, 30),  "q")
    assert_equal "4", format(Date.new(2010, 10,  1), "q")
    assert_equal "4", format(Date.new(2010, 12, 31), "q")
  end

  test "pattern qq" do
    assert_equal "01", format(Date.new(2010, 1,  1),  "qq")
    assert_equal "01", format(Date.new(2010, 3, 31),  "qq")
    assert_equal "02", format(Date.new(2010, 4,  1),  "qq")
    assert_equal "02", format(Date.new(2010, 6, 30),  "qq")
    assert_equal "03", format(Date.new(2010, 7,  1),  "qq")
    assert_equal "03", format(Date.new(2010, 9, 30),  "qq")
    assert_equal "04", format(Date.new(2010, 10,  1), "qq")
    assert_equal "04", format(Date.new(2010, 12, 31), "qq")
  end

  # requires "multiple inheritance"
  #
  # test "pattern qqq" do
  #   assert_equal 'Q1', format(Date.new(2010, 1,  1),  'qqq')
  #   assert_equal 'Q1', format(Date.new(2010, 3, 31),  'qqq')
  #   assert_equal 'Q2', format(Date.new(2010, 4,  1),  'qqq')
  #   assert_equal 'Q2', format(Date.new(2010, 6, 30),  'qqq')
  #   assert_equal 'Q3', format(Date.new(2010, 7,  1),  'qqq')
  #   assert_equal 'Q3', format(Date.new(2010, 9, 30),  'qqq')
  #   assert_equal 'Q4', format(Date.new(2010, 10,  1), 'qqq')
  #   assert_equal 'Q4', format(Date.new(2010, 12, 31), 'qqq')
  # end
  #
  # test "pattern qqqq" do
  #   assert_equal '1. Quartal', format(Date.new(2010, 1,  1),  'qqqq')
  #   assert_equal '1. Quartal', format(Date.new(2010, 3, 31),  'qqqq')
  #   assert_equal '2. Quartal', format(Date.new(2010, 4,  1),  'qqqq')
  #   assert_equal '2. Quartal', format(Date.new(2010, 6, 30),  'qqqq')
  #   assert_equal '3. Quartal', format(Date.new(2010, 7,  1),  'qqqq')
  #   assert_equal '3. Quartal', format(Date.new(2010, 9, 30),  'qqqq')
  #   assert_equal '4. Quartal', format(Date.new(2010, 10,  1), 'qqqq')
  #   assert_equal '4. Quartal', format(Date.new(2010, 12, 31), 'qqqq')
  # end

  test "pattern qqqqq" do
    assert_equal "1", format(Date.new(2010, 1,  1),  "qqqqq")
    assert_equal "1", format(Date.new(2010, 3, 31),  "qqqqq")
    assert_equal "2", format(Date.new(2010, 4,  1),  "qqqqq")
    assert_equal "2", format(Date.new(2010, 6, 30),  "qqqqq")
    assert_equal "3", format(Date.new(2010, 7,  1),  "qqqqq")
    assert_equal "3", format(Date.new(2010, 9, 30),  "qqqqq")
    assert_equal "4", format(Date.new(2010, 10,  1), "qqqqq")
    assert_equal "4", format(Date.new(2010, 12, 31), "qqqqq")
  end

  # MONTH

  test "pattern M" do
    assert_equal   "1", format(Date.new(2010,  1, 1), "M")
    assert_equal  "10", format(Date.new(2010, 10, 1), "M")
  end

  test "pattern MM" do
    assert_equal "01", format(Date.new(2010,  1, 1), "MM")
    assert_equal "10", format(Date.new(2010, 10, 1), "MM")
  end

  test "pattern MMM" do
    assert_equal "Jan.", format(Date.new(2010,  1, 1), "MMM")
    assert_equal "Okt.", format(Date.new(2010, 10, 1), "MMM")
  end

  test "pattern MMMM" do
    assert_equal "Januar",  format(Date.new(2010,  1, 1), "MMMM")
    assert_equal "Oktober", format(Date.new(2010, 10, 1), "MMMM")
  end

  # requires cldr's "multiple inheritance"
  #
  # test "pattern MMMMM" do
  #   assert_equal 'J', format(Date.new(2010,  1, 1), 'MMMMM')
  #   assert_equal 'O', format(Date.new(2010, 10, 1), 'MMMMM')
  # end

  test "pattern L" do
    assert_equal   "1", format(Date.new(2010,  1, 1), "L")
    assert_equal  "10", format(Date.new(2010, 10, 1), "L")
  end

  test "pattern LL" do
    assert_equal "01", format(Date.new(2010,  1, 1), "LL")
    assert_equal "10", format(Date.new(2010, 10, 1), "LL")
  end

  # requires cldr's "multiple inheritance"
  #
  # test "pattern LLL" do
  #   assert_equal 'Jan', format(Date.new(2010,  1, 1), 'LLL')
  #   assert_equal 'Okt', format(Date.new(2010, 10, 1), 'LLL')
  # end
  #
  # test "pattern LLLL" do
  #   assert_equal 'Januar',  format(Date.new(2010,  1, 1), 'LLLL')
  #   assert_equal 'Oktober', format(Date.new(2010, 10, 1), 'LLLL')
  # end
  #
  # test "pattern LLLLL" do
  #   assert_equal 'J', format(Date.new(2010,  1, 1), 'LLLLL')
  #   assert_equal 'O', format(Date.new(2010, 10, 1), 'LLLLL')
  # end

  test "pattern LLLLL" do
    assert_equal "J", format(Date.new(2010,  1, 1), "LLLLL")
    assert_equal "O", format(Date.new(2010, 10, 1), "LLLLL")
  end

  # DAY

  test "pattern d" do
    assert_equal  "1", format(Date.new(2010, 1,  1), "d")
    assert_equal "10", format(Date.new(2010, 1, 10), "d")
  end

  test "pattern dd" do
    assert_equal "01", format(Date.new(2010, 1,  1), "dd")
    assert_equal "10", format(Date.new(2010, 1, 10), "dd")
  end

  test "pattern E, EE, EEE" do
    assert_equal "Fr.", format(Date.new(2010, 1, 1), "E")
    assert_equal "Fr.", format(Date.new(2010, 1, 1), "EE")
    assert_equal "Fr.", format(Date.new(2010, 1, 1), "EEE")
  end

  test "pattern EEEE" do
    assert_equal "Freitag", format(Date.new(2010, 1, 1), "EEEE")
  end

  test "pattern EEEEE" do
    assert_equal "F", format(Date.new(2010, 1, 1), "EEEEE")
  end
end