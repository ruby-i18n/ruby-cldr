# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../../test_helper"))

class TestCldrDataFields < Test::Unit::TestCase
  test "Alias nodes are exported as paths to their targets" do
    data = Cldr::Export::Data::Fields.new(:root)
    path = data.dig(:fields, :day_narrow)
    assert_equal :"fields.day_short", path

    path = data.dig(*split_path_string(path))
    assert_equal :"fields.day", path

    day = data.dig(*split_path_string(path))
    assert_not_nil day
  end

  private

  def split_path_string(path)
    path.to_s.split(".").map(&:to_sym)
  end
end
