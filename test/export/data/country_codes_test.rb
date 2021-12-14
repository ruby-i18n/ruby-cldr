# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../../test_helper"))

class TestCldrDataCountryCodes < Test::Unit::TestCase
  test "country codes" do
    expected =
      {
        AA: {
          "numeric" => "958",
          "alpha3" => "AAA",
        },
        AC: {
          "alpha3" => "ASC",
        },
      }
    country_codes = Cldr::Export::Data::CountryCodes.new
    assert_equal(country_codes[:country_codes][:AA], expected[:AA])
    assert_equal(country_codes[:country_codes][:AC], expected[:AC])
  end
end
