# frozen_string_literal: true

require File.join(File.expand_path(File.dirname(__FILE__)), "../test_helper")

class TestFlattenedDataSet < Test::Unit::TestCase
  def setup
    Cldr::Export.minimum_draft_status = Cldr::DraftStatus::CONTRIBUTED
    @file_based_data_set = Cldr::Export::FileBasedDataSet.new(directory: File.expand_path("./test/fixtures/cldr/common"))
    @test_data_set = Cldr::Export::FlattenedDataSet.new(parent: @file_based_data_set)
  end

  test "Does nothing by default" do
    assert_equal(@file_based_data_set[:de], @test_data_set[:de])
  end

  test "Aliases are sorted correctly" do
    aliases = @file_based_data_set[:root].xpath("//alias")

    expected = [aliases[1], aliases[2], aliases[0]]

    assert_equal(expected, @test_data_set.send(:aliases))
  end

  test "Does alias flattening without other flattening" do
    expected = <<~XML_CONTENTS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE ldml SYSTEM "../../common/dtd/ldml.dtd">
      <!-- Copyright © 1991-2022 Unicode, Inc.
      For terms of use, see http://www.unicode.org/copyright.html
      SPDX-License-Identifier: Unicode-DFS-2016
      CLDR data files are interpreted according to the LDML specification (http://unicode.org/reports/tr35/)

      Warnings: All cp values have U+FE0F characters removed. See /annotationsDerived/ for derived annotations.
      -->
      <ldml>
        <identity>
          <version number="$Revision$"/>
          <language type="de"/>
        </identity>
        <units>
          <unitLength type="long">
            <unit type="mass-kilogram">
              <gender>neuter</gender>
              <displayName>Kilogramm</displayName>
              <unitPattern count="one">{0} Kilogramm</unitPattern>
              <unitPattern count="one" case="accusative">{0} Kilogramm</unitPattern>
              <unitPattern count="one" case="dative">{0} Kilogramm</unitPattern>
              <unitPattern count="one" case="genitive">{0} Kilogramms</unitPattern>
              <unitPattern count="other">{0} Kilogramm</unitPattern>
              <unitPattern count="other" case="accusative">{0} Kilogramm</unitPattern>
              <unitPattern count="other" case="dative">{0} Kilogramm</unitPattern>
              <unitPattern count="other" case="genitive">{0} Kilogramm</unitPattern>
              <perUnitPattern>{0} pro Kilogramm</perUnitPattern>
            </unit>
            <unit type="mass-gram">
              <gender>neuter</gender>
              <displayName>Gramm (from type="long")</displayName>
              <unitPattern count="one">{0} Gramm</unitPattern>
              <unitPattern count="one" case="accusative">{0} Gramm</unitPattern>
              <unitPattern count="one" case="dative">{0} Gramm</unitPattern>
              <unitPattern count="one" case="genitive">{0} Gramms</unitPattern>
              <unitPattern count="other">{0} Gramm</unitPattern>
              <unitPattern count="other" case="accusative">{0} Gramm</unitPattern>
              <unitPattern count="other" case="dative">{0} Gramm</unitPattern>
              <unitPattern count="other" case="genitive">{0} Gramm</unitPattern>
              <perUnitPattern>{0} pro Gramm</perUnitPattern>
            </unit>
            <unit type="duration-year">
              <displayName>J</displayName>
              <unitPattern count="one">{0} J</unitPattern>
              <unitPattern count="other">{0} J</unitPattern>
              <perUnitPattern>{0}/J</perUnitPattern>
            </unit>
            <unit type="duration-year-person">
              <displayName>J</displayName>
              <unitPattern count="one">{0} J</unitPattern>
              <unitPattern count="other">{0} J</unitPattern>
              <perUnitPattern>{0}/J</perUnitPattern>
            </unit>
          </unitLength>
          <unitLength type="short">
            <unit type="duration-year">
              <displayName>J</displayName>
              <unitPattern count="one">{0} J</unitPattern>
              <unitPattern count="other">{0} J</unitPattern>
              <perUnitPattern>{0}/J</perUnitPattern>
            </unit>
            <unit type="mass-gram">
              <displayName>Gramm</displayName>
            </unit>
            <unit type="duration-year-person">
              <displayName>J</displayName>
              <unitPattern count="one">{0} J</unitPattern>
              <unitPattern count="other">{0} J</unitPattern>
              <perUnitPattern>{0}/J</perUnitPattern>
            </unit>
          </unitLength>
          <unitLength type="narrow">
            <unit type="duration-year">
              <displayName>J</displayName>
              <unitPattern count="one">{0} J</unitPattern>
              <unitPattern count="other">{0} J</unitPattern>
              <perUnitPattern>{0}/J</perUnitPattern>
            </unit>
            <unit type="mass-gram">
              <displayName>Gramm</displayName>
            </unit>
            <unit type="duration-year-person">
              <displayName>J</displayName>
              <unitPattern count="one">{0} J</unitPattern>
              <unitPattern count="other">{0} J</unitPattern>
              <perUnitPattern>{0}/J</perUnitPattern>
            </unit>
          </unitLength>
        </units>
      </ldml>
    XML_CONTENTS

    assert_equal(expected, @test_data_set.send(:flatten, :de, flatten_aliases: true).doc.to_xml)
  end
end
