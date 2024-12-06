# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../../test_helper"))

class TestLocaleDisplayPattern < Test::Unit::TestCase
  test "locale_display_pattern :de" do
    expected = {
      "locale_key_type_pattern" => "{0}: {1}",
      "locale_pattern" => "{0} ({1})",
      "locale_separator" => "{0}, {1}",
    }

    actual = Cldr::Export::Data::LocaleDisplayPattern.new(:de)[:locale_display_pattern]

    assert_equal expected, actual
  end
end
