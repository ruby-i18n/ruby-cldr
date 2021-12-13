# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__) + '/../test_helper'))

class TestFallbacks < Test::Unit::TestCase
  test "fallbacks does basic hyphen chopping" do
    assert_equal [:root], Cldr.fallbacks[:root]
    assert_equal [:en, :root], Cldr.fallbacks[:en]
    assert_equal [:"fr-CA", :fr, :root], Cldr.fallbacks[:"fr-CA"]
    assert_equal [:"zh-Hant-HK", :"zh-Hant", :root], Cldr.fallbacks[:"zh-Hant-HK"]
  end

  test "fallbacks observe explicit parent overrides" do
    assert_equal [:"az-Arab", :root], Cldr.fallbacks[:"az-Arab"]
    assert_equal [:"en-CH", :"en-150", :"en-001", :en, :root], Cldr.fallbacks[:"en-CH"]
    assert_equal [:"zh-Hant", :root], Cldr.fallbacks[:"zh-Hant"]
  end
end
