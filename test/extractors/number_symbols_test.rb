# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper.rb'

class TestCldrDataNumberSymbols < Test::Unit::TestCase
  define_method "test: number_symbols" do
    expected = {
      :numbers => {
        :symbols => {
          :nan               => "NaN",
          :decimal           => ",",
          :plus_sign         => "+",
          :minus_sign        => "-",
          :group             => ".",
          :exponential       => "E",
          :percent_sign      => "%",
          :list              => ";",
          :per_mille         => "‰",
          :native_zero_digit => "0",
          :infinity          => "∞",
          :pattern_digit     => "#"
        }
      }
    }
    assert_equal expected, Cldr::Data::NumberSymbols.new('de').data
  end
end