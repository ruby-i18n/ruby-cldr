require File.dirname(__FILE__) + '/../test_helper'

class TestCldrNumberFormat < Test::Unit::TestCase
  define_method "test: positive pattern, positive number" do
    assert_equal '123', Cldr::Format::Number.new('#').apply(123)
  end

  define_method "test: positive pattern, negative number" do
    assert_equal '-123', Cldr::Format::Number.new('#').apply(-123)
  end
  
  define_method "test: positive/negative patterns, positive number" do
    assert_equal '123', Cldr::Format::Number.new('#;-#').apply(123)
  end
  
  define_method "test: positive/negative patterns, negative number" do
    assert_equal '-123', Cldr::Format::Number.new('#;-#').apply(-123)
  end
end
