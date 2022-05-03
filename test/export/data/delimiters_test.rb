# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../../test_helper"))

class TestCldrDataDelimiters < Test::Unit::TestCase
  test "delimiters :de" do
    expected = {
      delimiters: {
        quotes: {
          default: {
            start: "„",
            end: "“",
          },
          alternate: {
            start: "‚",
            end: "‘",
          },
        },
      },
    }
    assert_equal expected, Cldr::Export::Data::Delimiters.new(:de)
  end
end
