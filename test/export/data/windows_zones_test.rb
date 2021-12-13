# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__) + "/../../test_helper"))
require "time"

class TestCldrDataMetazones < Test::Unit::TestCase
  test "windows zone DE" do
    zones = Cldr::Export::Data::WindowsZones.new
    assert_equal( ["Europe/Berlin", "Europe/Busingen"], zones["W. Europe Standard Time"]["DE"])
  end

end
