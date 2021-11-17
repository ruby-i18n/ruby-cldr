# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__) + '/../test_helper'))
require File.expand_path(File.join(File.dirname(__FILE__) + '/../../lib/core_ext/hash/deep_prune'))

class TestDeepPrune < Test::Unit::TestCase
  test "deep_prune! returns empty Hash for empty Hash" do
    assert_equal({}, {}.deep_prune!)
  end

  test "deep_prune! with default comparator calls deep_prune! recursively and removes empty hashes" do
    hash = {
      "nil_value" => nil,
      "empty_hash" => {},
      "nested_empty_hash" => {
        "foo" => {},
      },
      "nested_non_empty_hash" => {
        "bar" => "baz",
      },
      "empty_string" => "",
      "empty_array" => [],
      "integer" => 1,
    }

    expected = {
      "nil_value" => nil,
      "nested_non_empty_hash" => {
        "bar" => "baz",
      },
      "empty_string" => "",
      "empty_array" => [],
      "integer" => 1,
    }
    assert_equal(expected, hash.deep_prune!)
  end

  test "deep_prune! can be called with other comparators to removes blank items" do
    blank = ->(v) { v.respond_to?(:empty?) ? !!v.empty? : !v } # Rails' Object#blank?

    hash = {
      "nil_value" => nil,
      "empty_hash" => {},
      "empty_string" => "",
      "empty_array" => [],
      "integer" => 1,
      "nested_empty_hash" => {
        "foo" => {},
        "nil_empty_value" => nil,
        "nested_empty_string" => "",
        "nested_empty_array" => [],
      },
      "nested_non_empty_hash" => {
        "bar" => "baz",
      },

    }

    expected = {
      "integer" => 1,
      "nested_non_empty_hash" => {
        "bar" => "baz",
      },
    }
    assert_equal(expected, hash.deep_prune!(blank))
  end
end
