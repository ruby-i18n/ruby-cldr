# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__) + "/../test_helper"))
require "date"

class TestCldrDateTimeFormat < Test::Unit::TestCase
  def setup
    @locale = :de
    @calendar = Cldr::Export::Data::Calendars.new(@locale)[:calendars][:gregorian]
  end

  def format(object, pattern)
    Cldr::Format::Time.new(pattern, @calendar).apply(object)
  end
  
  # FORMATS
  
  # Timezone missing
  #
  # test "full time pattern :de" do
  #   assert_equal '13:12:11 zzzz', format(Time.local(2000, 1, 1, 13, 12, 11), 'HH:mm:ss zzzz')
  # end
  
  test "long time pattern :de" do
    assert_equal "13:12:11 UTC", format(Time.utc(2010, 1, 1, 13, 12, 11), "HH:mm:ss z")
  end

  test "medium time pattern :de" do
    assert_equal "13:12:11", format(Time.utc(2010, 1, 1, 13, 12, 11), "HH:mm:ss")
  end

  test "short time pattern :de" do
    assert_equal "13:12", format(Time.utc(2010, 1, 1, 13, 12, 11), "HH:mm")
  end
  
  # TIMEZONE

  test "z, zz, zzz" do # TODO is this what's meant by the spec?
    assert_equal  "UTC", format(Time.utc(2000, 1, 1, 1, 1,  1), "z")
    assert_equal  "UTC", format(Time.utc(2000, 1, 1, 1, 1,  1), "zz")
    assert_equal  "UTC", format(Time.utc(2000, 1, 1, 1, 1,  1), "zzz")
  end
  
  # PERIOD

  test "period" do
    assert_equal "AM", format(Time.local(2000, 1, 1, 1, 1, 1), "a")
    assert_equal "PM", format(Time.local(2000, 1, 1, 15, 1, 1), "a")
  end
  
  # HOUR

  test "h" do
    assert_equal "12", format(Time.local(2000, 1, 1,  0, 1, 1), "h")
    assert_equal  "1", format(Time.local(2000, 1, 1,  1, 1, 1), "h")
    assert_equal "11", format(Time.local(2000, 1, 1, 11, 1, 1), "h")
    assert_equal "12", format(Time.local(2000, 1, 1, 12, 1, 1), "h")
    assert_equal "11", format(Time.local(2000, 1, 1, 23, 1, 1), "h")
  end

  test "hh" do
    assert_equal "12", format(Time.local(2000, 1, 1,  0, 1, 1), "hh")
    assert_equal "01", format(Time.local(2000, 1, 1,  1, 1, 1), "hh")
    assert_equal "11", format(Time.local(2000, 1, 1, 11, 1, 1), "hh")
    assert_equal "12", format(Time.local(2000, 1, 1, 12, 1, 1), "hh")
    assert_equal "11", format(Time.local(2000, 1, 1, 23, 1, 1), "hh")
  end

  test "H" do
    assert_equal  "0", format(Time.local(2000, 1, 1,  0, 1, 1), "H")
    assert_equal  "1", format(Time.local(2000, 1, 1,  1, 1, 1), "H")
    assert_equal "11", format(Time.local(2000, 1, 1, 11, 1, 1), "H")
    assert_equal "12", format(Time.local(2000, 1, 1, 12, 1, 1), "H")
    assert_equal "23", format(Time.local(2000, 1, 1, 23, 1, 1), "H")
  end

  test "HH" do
    assert_equal "00", format(Time.local(2000, 1, 1,  0, 1, 1), "HH")
    assert_equal "01", format(Time.local(2000, 1, 1,  1, 1, 1), "HH")
    assert_equal "11", format(Time.local(2000, 1, 1, 11, 1, 1), "HH")
    assert_equal "12", format(Time.local(2000, 1, 1, 12, 1, 1), "HH")
    assert_equal "23", format(Time.local(2000, 1, 1, 23, 1, 1), "HH")
  end

  test "K" do
    assert_equal  "0", format(Time.local(2000, 1, 1,  0, 1, 1), "K")
    assert_equal  "1", format(Time.local(2000, 1, 1,  1, 1, 1), "K")
    assert_equal "11", format(Time.local(2000, 1, 1, 11, 1, 1), "K")
    assert_equal  "0", format(Time.local(2000, 1, 1, 12, 1, 1), "K")
    assert_equal "11", format(Time.local(2000, 1, 1, 23, 1, 1), "K")
  end

  test "KK" do
    assert_equal "00", format(Time.local(2000, 1, 1,  0, 1, 1), "KK")
    assert_equal "01", format(Time.local(2000, 1, 1,  1, 1, 1), "KK")
    assert_equal "11", format(Time.local(2000, 1, 1, 11, 1, 1), "KK")
    assert_equal "00", format(Time.local(2000, 1, 1, 12, 1, 1), "KK")
    assert_equal "11", format(Time.local(2000, 1, 1, 23, 1, 1), "KK")
  end

  test "k" do
    assert_equal "24", format(Time.local(2000, 1, 1,  0, 1, 1), "k")
    assert_equal  "1", format(Time.local(2000, 1, 1,  1, 1, 1), "k")
    assert_equal "11", format(Time.local(2000, 1, 1, 11, 1, 1), "k")
    assert_equal "12", format(Time.local(2000, 1, 1, 12, 1, 1), "k")
    assert_equal "23", format(Time.local(2000, 1, 1, 23, 1, 1), "k")
  end

  test "kk" do
    assert_equal "24", format(Time.local(2000, 1, 1,  0, 1, 1), "kk")
    assert_equal "01", format(Time.local(2000, 1, 1,  1, 1, 1), "kk")
    assert_equal "11", format(Time.local(2000, 1, 1, 11, 1, 1), "kk")
    assert_equal "12", format(Time.local(2000, 1, 1, 12, 1, 1), "kk")
    assert_equal "23", format(Time.local(2000, 1, 1, 23, 1, 1), "kk")
  end
  
  # MINUTE

  test "m" do
    assert_equal  "1", format(Time.local(2000, 1, 1, 1,  1, 1), "m")
    assert_equal "11", format(Time.local(2000, 1, 1, 1, 11, 1), "m")
  end

  test "mm" do
    assert_equal "01", format(Time.local(2000, 1, 1, 1,  1, 1), "mm")
    assert_equal "11", format(Time.local(2000, 1, 1, 1, 11, 1), "mm")
  end
  
  # SECOND

  test "s" do
    assert_equal  "1", format(Time.local(2000, 1, 1, 1, 1,  1), "s")
    assert_equal "11", format(Time.local(2000, 1, 1, 1, 1, 11), "s")
  end

  test "ss" do
    assert_equal "01", format(Time.local(2000, 1, 1, 1, 1,  1), "ss")
    assert_equal "11", format(Time.local(2000, 1, 1, 1, 1, 11), "ss")
  end

  # have i gotten the spec right here?
  test "S" do
    assert_equal "0", format(Time.local(2000, 1, 1, 1, 1, 1,      7), "S")
    assert_equal "0", format(Time.local(2000, 1, 1, 1, 1, 1,     77), "S")
    assert_equal "0", format(Time.local(2000, 1, 1, 1, 1, 1,    777), "S")
    assert_equal "0", format(Time.local(2000, 1, 1, 1, 1, 1,   7777), "S")
    assert_equal "1", format(Time.local(2000, 1, 1, 1, 1, 1,  77777), "S")
    assert_equal "8", format(Time.local(2000, 1, 1, 1, 1, 1, 777777), "S")
  end

  test "SS" do
    assert_equal "00", format(Time.local(2000, 1, 1, 1, 1, 1,      7), "SS")
    assert_equal "00", format(Time.local(2000, 1, 1, 1, 1, 1,     77), "SS")
    assert_equal "00", format(Time.local(2000, 1, 1, 1, 1, 1,    777), "SS")
    assert_equal "01", format(Time.local(2000, 1, 1, 1, 1, 1,   7777), "SS")
    assert_equal "08", format(Time.local(2000, 1, 1, 1, 1, 1,  77777), "SS")
    assert_equal "78", format(Time.local(2000, 1, 1, 1, 1, 1, 777777), "SS")
  end

  test "SSS" do
    assert_equal "000", format(Time.local(2000, 1, 1, 1, 1, 1,      7), "SSS")
    assert_equal "000", format(Time.local(2000, 1, 1, 1, 1, 1,     77), "SSS")
    assert_equal "001", format(Time.local(2000, 1, 1, 1, 1, 1,    777), "SSS")
    assert_equal "008", format(Time.local(2000, 1, 1, 1, 1, 1,   7777), "SSS")
    assert_equal "078", format(Time.local(2000, 1, 1, 1, 1, 1,  77777), "SSS")
    assert_equal "778", format(Time.local(2000, 1, 1, 1, 1, 1, 777777), "SSS")
  end

  test "SSSS" do
    assert_equal "0000", format(Time.local(2000, 1, 1, 1, 1, 1,      7), "SSSS")
    assert_equal "0001", format(Time.local(2000, 1, 1, 1, 1, 1,     77), "SSSS")
    assert_equal "0008", format(Time.local(2000, 1, 1, 1, 1, 1,    777), "SSSS")
    assert_equal "0078", format(Time.local(2000, 1, 1, 1, 1, 1,   7777), "SSSS")
    assert_equal "0778", format(Time.local(2000, 1, 1, 1, 1, 1,  77777), "SSSS")
    assert_equal "7778", format(Time.local(2000, 1, 1, 1, 1, 1, 777777), "SSSS")
  end

  test "SSSSS" do
    assert_equal "00001", format(Time.local(2000, 1, 1, 1, 1, 1,      7), "SSSSS")
    assert_equal "00008", format(Time.local(2000, 1, 1, 1, 1, 1,     77), "SSSSS")
    assert_equal "00078", format(Time.local(2000, 1, 1, 1, 1, 1,    777), "SSSSS")
    assert_equal "00778", format(Time.local(2000, 1, 1, 1, 1, 1,   7777), "SSSSS")
    assert_equal "07778", format(Time.local(2000, 1, 1, 1, 1, 1,  77777), "SSSSS")
    assert_equal "77778", format(Time.local(2000, 1, 1, 1, 1, 1, 777777), "SSSSS")
  end

  test "SSSSSS" do
    assert_equal "000007", format(Time.local(2000, 1, 1, 1, 1, 1,      7), "SSSSSS")
    assert_equal "000077", format(Time.local(2000, 1, 1, 1, 1, 1,     77), "SSSSSS")
    assert_equal "000777", format(Time.local(2000, 1, 1, 1, 1, 1,    777), "SSSSSS")
    assert_equal "007777", format(Time.local(2000, 1, 1, 1, 1, 1,   7777), "SSSSSS")
    assert_equal "077777", format(Time.local(2000, 1, 1, 1, 1, 1,  77777), "SSSSSS")
    assert_equal "777777", format(Time.local(2000, 1, 1, 1, 1, 1, 777777), "SSSSSS")
  end
end