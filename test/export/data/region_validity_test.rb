# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../../test_helper"))

class TestCldrDataRegionValidity < Test::Unit::TestCase
  test "region validity" do
    region_validity = Cldr::Export::Data::RegionValidity.new[:validity][:regions]
    assert_include(region_validity[:regular], "AD")
    assert_equal(region_validity[:regular].size, 256)

    assert_include(region_validity[:special], "XB")
    assert_equal(region_validity[:special].size, 2)

    assert_include(region_validity[:macroregion], "002")
    assert_equal(region_validity[:macroregion].size, 35)

    assert_include(region_validity[:deprecated], "YU")
    assert_equal(region_validity[:deprecated].size, 12)

    assert_include(region_validity[:reserved], "QN")
    assert_equal(region_validity[:reserved].size, 13)

    assert_include(region_validity[:private_use], "XD")
    assert_equal(region_validity[:private_use].size, 23)

    assert_include(region_validity[:unknown], "ZZ")
    assert_equal(region_validity[:unknown].size, 1)
  end
end
