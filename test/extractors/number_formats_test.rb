# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper.rb'

class TestCldrDataNumberFormats < Test::Unit::TestCase
  define_method "test: number_formats :de" do
    expected = {
      :numbers => {
        :formats => {
          :decimal => {
            :pattern => "#,##0.###"
          },
          :percent => {
            :pattern => "#,##0 %"      # includes a non-breaking space (\302\240)
          },
          :currency => {
            :pattern  => "#,##0.00 ¤", # includes a non-breaking space (\302\240)
            :unit => {
              "one"   => "{0} {1}", 
              "other" => "{0} {1}"
            }
          },
          :scientific => {
            :pattern => "#E0"
          }
        }
      }
    }
    assert_equal expected, Cldr::Data::NumberFormats.new('de').data
  end

  Cldr::Data.locales.each do |locale|
    define_method "test: extract number_formats for #{locale}" do
      Cldr::Data::NumberFormats.new(locale).data
    end
  end
end