# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../test_helper"))
require File.expand_path(File.join(File.dirname(__FILE__) + "/../../lib/core_ext/hash/deep_stringify"))

class TestDeepPrune < Test::Unit::TestCase
  test "deep_stringify_keys doesn't affect values" do
    input = {
      foo: :bar,
      parent: {
        nested: :baz,
      },
    }
    expected = {
      "foo" => :bar,
      "parent" => {
        "nested" => :baz,
      },
    }
    assert_equal expected, input.deep_stringify_keys
  end
end
