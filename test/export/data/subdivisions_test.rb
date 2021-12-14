# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../../test_helper"))

class TestCldrDataSubdivisions < Test::Unit::TestCase
  test "subdivisions for Canada/Quebec in :ja" do
    subdivisions = Cldr::Export::Data::Subdivisions.new(:ja)[:subdivisions]

    assert_equal("ケベック州", subdivisions[:caqc])
  end

  test "subdivisions for a non an unsupported locale :zz" do
    subdivisions = Cldr::Export::Data::Subdivisions.new(:zz)

    assert_empty(subdivisions)
  end

  test "subdivisions locales are a subset of main locales" do
    root = File.expand_path("./vendor/cldr/common")

    main_locales = Dir["#{root}/main/*.xml"].map { |path| path =~ /([\w_-]+)\.xml/ && Regexp.last_match(1) }
    subdivisions_locales = Dir["#{root}/subdivisions/*.xml"].map { |path| path =~ /([\w_-]+)\.xml/ && Regexp.last_match(1) }

    assert_empty(subdivisions_locales - main_locales)
  end

  #
  #   test "extract subdivisions for #{locale}" do
  #     assert_nothing_raised do
  #       Cldr::Export::Data::Subdivisions.new(locale)
  #     end
  #   end
end
