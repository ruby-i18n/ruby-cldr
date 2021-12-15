# encoding: utf-8
# frozen_string_literal: true

require "yaml"

require File.expand_path(File.join(File.dirname(__FILE__) + "/../../test_helper"))

class TestParentLocales < Test::Unit::TestCase
  test "ParentLocales uses symbols for keys and values" do
    data = Cldr::Export.data("ParentLocales", {})
    assert data.all? { |key, value| key.is_a?(Symbol) && value.is_a?(Symbol) }, "Not all keys and values are Symbols"
  end

  test "ParentLocales#to_h uses strings for keys and values" do
    data = Cldr::Export.data("ParentLocales", {}).to_h
    assert data.all? { |key, value| key.is_a?(String) && value.is_a?(String) }, "Not all keys and values are Strings"
  end
end
