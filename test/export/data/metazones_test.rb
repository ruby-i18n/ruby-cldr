# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../../test_helper"))
require "date"

class TestCldrDataMetazones < Test::Unit::TestCase
  test "metazone timezones" do
    timezones = Cldr::Export::Data::Metazones.new[:timezones]
    assert_equal({ "from" => DateTime.parse("1990-05-05T21:00:00+00:00"), "metazone" => "Europe_Eastern" }, timezones[:"Europe/Chisinau"].last)
  end

  test "metazone primaryzones" do
    primaryzones = Cldr::Export::Data::Metazones.new[:primaryzones]
    assert_equal("Europe/Berlin", primaryzones[:"DE"])
  end
end
