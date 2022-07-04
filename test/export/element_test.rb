# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../test_helper"))

class TestElement < Test::Unit::TestCase
  setup do
    directory = File.expand_path("./vendor/cldr/common")
    @data_set = Cldr::Export::FileBasedDataSet.new(directory: directory)
    @en_file = @data_set[:en]
    @root_file = @data_set[:root]
  end

  test "Sorts the attributes in element chain by name" do
    node = @en_file.xpath("//language[@type='en_GB'][@alt='short']").first
    assert_equal("/ldml/localeDisplayNames/languages/language[@alt=\"short\"][@type=\"en_GB\"]", Cldr::Export::Element.chain(node))
  end

  test "Inheritance element chain only includes distinguishing attributes" do
    node = @root_file.xpath("//calendar[@type='hebrew']/months/monthContext[@type='format']/monthWidth[@type='abbreviated']/alias").first
    assert_equal("/ldml/dates/calendars/calendar[@type=\"hebrew\"]/months/monthContext[@type=\"format\"]/monthWidth[@type=\"abbreviated\"]/alias[@path=\"../monthWidth[@type='wide']\"][@source=\"locale\"]", Cldr::Export::Element.chain(node))
    assert_equal("/ldml/dates/calendars/calendar[@type=\"hebrew\"]/months/monthContext[@type=\"format\"]/monthWidth[@type=\"abbreviated\"]/alias", Cldr::Export::Element.inheritance_chain(node))
  end
end
