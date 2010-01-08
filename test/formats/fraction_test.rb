require File.dirname(__FILE__) + '/../test_helper'

class TestCldrFractionFormatWithInteger < Test::Unit::TestCase
  define_method "test: formats a fraction" do
    assert_equal '.45', Cldr::Format::Fraction.new('###.##').apply('45')
  end
  
  define_method "test: pads zero digits on the right side" do
    assert_equal '.4500', Cldr::Format::Fraction.new('###.0000#').apply('45')
  end
  
  define_method "test: :precision option overrides format precision" do
    assert_equal '.78901', Cldr::Format::Fraction.new('###.##').apply('78901', :precision => 5)
  end
end


