# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../../test_helper"))

class TestCldrDataLists < Test::Unit::TestCase
  test "Alias nodes are exported as paths to their targets" do
    data = Cldr::Export::Data::Lists.new(:root)
    path = data.dig(:lists, :or_narrow)
    assert_equal :"lists.or_short", path

    path = data.dig(*split_path_string(path))
    assert_equal :"lists.or", path

    pattern_or = data.dig(*split_path_string(path))
    assert_not_nil pattern_or
  end

  private

  def split_path_string(path)
    path.to_s.split(".").map(&:to_sym)
  end
end
