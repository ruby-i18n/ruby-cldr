# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../test_helper"))
require File.expand_path(File.join(File.dirname(__FILE__) + "/../../lib/cldr/export/deep_validate_keys"))

class TestDeepValidateKeys < Test::Unit::TestCase
  test "#paths_match with empty pattern matches only empty key" do
    assert DeepValidateKeys.send(:paths_match, [], [])
    refute DeepValidateKeys.send(:paths_match, [], ["foo", "bar", "baz", "qux"])
  end

  test "#paths_match matches with exact match" do
    assert DeepValidateKeys.send(:paths_match, ["foo", "bar"], ["foo", "bar"])

    refute DeepValidateKeys.send(:paths_match, ["foo"], ["foo", "bar", "baz", "qux"])
    refute DeepValidateKeys.send(:paths_match, ["foo"], ["bar", "baz", "qux"])
    refute DeepValidateKeys.send(:paths_match, ["foo", "bar"], ["foo"])
    refute DeepValidateKeys.send(:paths_match, ["foo", "baz"], ["foo", "bar", "baz", "qux"])
  end

  test "#paths_match with . matches single element" do
    assert DeepValidateKeys.send(:paths_match, ["foo", ".", "baz"], ["foo", "bar", "baz"])
    assert DeepValidateKeys.send(:paths_match, ["foo", ".", ".", "qux"], ["foo", "bar", "baz", "qux"])
    assert DeepValidateKeys.send(:paths_match, ["."], ["foo"])
    assert DeepValidateKeys.send(:paths_match, [".", "bar"], ["foo", "bar"])

    refute DeepValidateKeys.send(:paths_match, ["."], [])
  end

  test "#paths_match with trailing * matches anything after the star" do
    assert DeepValidateKeys.send(:paths_match, ["foo", "*"], ["foo", "bar", "baz", "qux"])
    assert DeepValidateKeys.send(:paths_match, ["*"], [])
    assert DeepValidateKeys.send(:paths_match, ["*"], ["foo", "bar", "baz", "qux"])
  end

  test "#paths_match with * greedy matches up to the last match of the next element" do
    assert DeepValidateKeys.send(:paths_match, ["foo", "*", "baz", "quxx"], ["foo", "bar", "baz", "qux", "baz", "quxx"])

    refute DeepValidateKeys.send(:paths_match, ["foo", "*", "baz", "quxx"], ["foo", "bar", "baz", "qux"])
  end

  test "#paths_match raise when given a pattern with multiple *" do
    exc = assert_raises(NotImplementedError) do
      DeepValidateKeys.send(:paths_match, ["foo", "*", "baz", "*"], ["foo", "bar", "baz", "qux", "baz", "quxx"])
    end
    assert_equal "Multiple * in pattern is unsupported", exc.message
  end
end
