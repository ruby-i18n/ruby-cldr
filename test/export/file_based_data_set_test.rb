# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../test_helper"))

class TestFileBasedDataSet < Test::Unit::TestCase
  test "#paths finds all the language-dependent data files" do
    directory = File.expand_path("./vendor/cldr/common")
    data_set = Cldr::Export::FileBasedDataSet.new(directory: directory)

    expected = [
      "annotations/af.xml",
      "annotationsDerived/af.xml",
      "casing/af.xml",
      "collation/af.xml",
      "main/af.xml",
      "rbnf/af.xml",
      "subdivisions/af.xml",
    ].map { |f| File.join(directory, f) }
    assert_equal expected, data_set.send(:paths, :af)
  end

  test "#paths finds all the supplemental data files" do
    directory = File.expand_path("./vendor/cldr/common")
    data_set = Cldr::Export::FileBasedDataSet.new(directory: directory)

    expected_non_transform_files = [
      "supplemental-temp/coverageLevels2.xml",
      "supplemental/attributeValueValidity.xml",
      "supplemental/characters.xml",
      "supplemental/coverageLevels.xml",
      "supplemental/dayPeriods.xml",
      "supplemental/genderList.xml",
      "supplemental/grammaticalFeatures.xml",
      "supplemental/languageGroup.xml",
      "supplemental/languageInfo.xml",
      "supplemental/likelySubtags.xml",
      "supplemental/metaZones.xml",
      "supplemental/numberingSystems.xml",
      "supplemental/ordinals.xml",
      "supplemental/pluralRanges.xml",
      "supplemental/plurals.xml",
      "supplemental/rgScope.xml",
      "supplemental/subdivisions.xml",
      "supplemental/supplementalData.xml",
      "supplemental/supplementalMetadata.xml",
      "supplemental/units.xml",
      "supplemental/windowsZones.xml",
      "validity/currency.xml",
      "validity/language.xml",
      "validity/region.xml",
      "validity/script.xml",
      "validity/subdivision.xml",
      "validity/unit.xml",
      "validity/variant.xml",
    ].map { |f| File.join(directory, f) }

    supplemental_data_paths = data_set.send(:paths, nil)

    assert_equal expected_non_transform_files, supplemental_data_paths.reject { |p| p.include?("transforms/") }
    assert_not_empty supplemental_data_paths.select { |p| p.include?("transforms/") }
  end
end
