# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper.rb'

class TestCldrDataNumberSymbols < Test::Unit::TestCase
  define_method "test: number_symbols :de" do
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

  Cldr::Data.locales.each do |locale|
    define_method "test: extract number_symbols for #{locale}" do
      Cldr::Data::NumberSymbols.new(locale).data
    end
  end
end