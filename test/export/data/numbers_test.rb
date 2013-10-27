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
      :infinity          => "∞",
      :superscripting_exponent => "·"
    }
    assert_equal expected, Cldr::Export::Data::Numbers.new('de')[:numbers][:symbols]
  end

  test "number formats :de" do
    expected = {
      :decimal => {
        :patterns => {
          :default => "#,##0.###",
          "long" => {
            "1000" => "0 Tausend",
            "10000" => "00 Tausend",
            "100000" => "000 Tausend",
            "1000000" => "0 Millionen",
            "10000000" => "00 Millionen",
            "100000000" => "000 Millionen",
            "1000000000" => "0 Milliarden",
            "10000000000" => "00 Milliarden",
            "100000000000" => "000 Milliarden",
            "1000000000000" => "0 Billionen",
            "10000000000000" => "00 Billionen",
            "100000000000000" => "000 Billionen"
          },
          "short" => {
            "1000" => "0 Tsd",
            "10000" => "00 Tsd",
            "100000" => "000 Tsd",
            "1000000" => "0 Mio",
            "10000000" => "00 Mio",
            "100000000" => "000 Mio",
            "1000000000" => "0 Mrd",
            "10000000000" => "00 Mrd",
            "100000000000" => "000 Mrd",
            "1000000000000" => "0 Bio",
            "10000000000000" => "00 Bio",
            "100000000000000" => "000 Bio"
          }
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