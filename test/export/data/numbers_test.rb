# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__) + '/../../test_helper'))

class TestCldrDataNumbers < Test::Unit::TestCase
  test "number symbols :de" do
    expected = {
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
    assert_equal expected, Cldr::Export::Data::Numbers.new('de')[:numbers][:symbols]
  end

  test "number formats :de" do
    expected = {
      :decimal => {
        :patterns => {
          :default => "#,##0.###"
        }
      },
      :scientific => {
        :patterns => {
          :default => "#E0"
        }
      },
      :percent => {
        :patterns => {
          :default => "#,##0 %"     # includes a non-breaking space (\302\240)
        }
      },
      :currency => {
        :patterns => {
          :default => "#,##0.00 ¤", # includes a non-breaking space (\302\240)
        },
        :unit => {
          "one"   => "{0} {1}",
          "other" => "{0} {1}"
        }
      }
    }
    assert_equal expected, Cldr::Export::Data::Numbers.new('de')[:numbers][:formats]
  end

  # Cldr::Export::Data.locales.each do |locale|
  #   test "extract number_symbols for #{locale}" do
  #     assert_nothing_raised do
  #       Cldr::Export::Data::Numbers.new(locale)
  #     end
  #   end
  # end
end