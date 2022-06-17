# frozen_string_literal: true

require File.join(File.expand_path(File.dirname(__FILE__)), "../test_helper")

class TestDataFile < Test::Unit::TestCase
  def cldr_data
    File.read("#{Cldr::Export::Data::RAW_DATA.directory}/main/de.xml")
  end

  test "merging" do
    first_contents = <<~XML_CONTENTS
      <?xml version="1.0" encoding="UTF-8"?>
      <ldml>
        <identity>
          <version number="$Revision: 14491 $"/>
          <language type="de"/>
        </identity>
        <fields>
          <field type="quarter-narrow">
            <displayName>Q</displayName>
            <relativeTime type="future">
              <relativeTimePattern count="one">in {0} Q</relativeTimePattern>
              <relativeTimePattern count="other">in {0} Q</relativeTimePattern>
            </relativeTime>
            <relativeTime type="past">
              <relativeTimePattern count="one">vor {0} Q</relativeTimePattern>
              <relativeTimePattern count="other">vor {0} Q</relativeTimePattern>
            </relativeTime>
          </field>
        </fields>
      </ldml>
    XML_CONTENTS

    first_parsed = Cldr::Export::DataFile.parse(first_contents)

    second_contents = <<~XML_CONTENTS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE ldml SYSTEM "../../common/dtd/ldml.dtd">
      <ldml>
        <identity>
          <version number="$Revision: 11914 $"/>
          <language type="de"/>
        </identity>
        <segmentations>
          <segmentation type="SentenceBreak">
            <!--From ULI data, http://uli.unicode.org-->
            <suppressions type="standard">
              <suppression>Port.</suppression>
              <suppression>Alt.</suppression>
              <suppression>Di.</suppression>
              <suppression>Ges.</suppression>
            </suppressions>
          </segmentation>
        </segmentations>
      </ldml>
    XML_CONTENTS

    second_parsed = Cldr::Export::DataFile.parse(second_contents)

    merged = first_parsed.merge(second_parsed)

    # Inputs are unchanged
    assert_equal(first_contents, first_parsed.doc.to_xml)
    assert_equal(second_contents, second_parsed.doc.to_xml)

    merged_with_mutation = first_parsed.merge!(second_parsed)

    expected = <<~XML_CONTENTS
      <?xml version="1.0" encoding="UTF-8"?>
      <ldml>
        <identity>
          <version number="$Revision: 14491 $"/>
          <language type="de"/>
        </identity>
        <fields>
          <field type="quarter-narrow">
            <displayName>Q</displayName>
            <relativeTime type="future">
              <relativeTimePattern count="one">in {0} Q</relativeTimePattern>
              <relativeTimePattern count="other">in {0} Q</relativeTimePattern>
            </relativeTime>
            <relativeTime type="past">
              <relativeTimePattern count="one">vor {0} Q</relativeTimePattern>
              <relativeTimePattern count="other">vor {0} Q</relativeTimePattern>
            </relativeTime>
          </field>
        </fields>
        <identity>
          <version number="$Revision: 11914 $"/>
          <language type="de"/>
        </identity>
        <segmentations>
          <segmentation type="SentenceBreak">
            <!--From ULI data, http://uli.unicode.org-->
            <suppressions type="standard">
              <suppression>Port.</suppression>
              <suppression>Alt.</suppression>
              <suppression>Di.</suppression>
              <suppression>Ges.</suppression>
            </suppressions>
          </segmentation>
        </segmentations>
      </ldml>
    XML_CONTENTS

    assert_instance_of(Cldr::Export::DataFile, merged)
    assert_equal(expected, merged.doc.to_xml)
    assert_instance_of(Cldr::Export::DataFile, merged_with_mutation)
    assert_equal(expected, merged_with_mutation.doc.to_xml)
  end

  test "locale parsing" do
    xml_contents = <<~XML_CONTENTS
      <?xml version="1.0" encoding="UTF-8" ?>
      <ldml>
        <identity>
          <version number="$Revision: 14491 $"/>
          <language type="de"/>
        </identity>
      </ldml>
    XML_CONTENTS

    parsed = Cldr::Export::DataFile.parse(xml_contents)

    assert_equal(:de, parsed.locale)

    xml_contents = <<~XML_CONTENTS
      <?xml version="1.0" encoding="UTF-8" ?>
      <ldml>
        <identity>
          <version number="$Revision: 14491 $"/>
          <language type="de"/>
          <territory type="CH"/>
        </identity>
      </ldml>
    XML_CONTENTS

    parsed = Cldr::Export::DataFile.parse(xml_contents)

    assert_equal(:"de-CH", parsed.locale)
  end

  test "locale parsing returns nil when missing" do
    xml_contents = <<~XML_CONTENTS
      <?xml version="1.0" encoding="UTF-8" ?>
      <ldml>
        <identity>
          <version number="$Revision: 14491 $"/>
        </identity>
      </ldml>
    XML_CONTENTS

    parsed = Cldr::Export::DataFile.parse(xml_contents)

    assert_nil(parsed.locale)
  end
end

class TestDataFileDraftStatusFilter < Test::Unit::TestCase
  def setup; end # We don't want the default behaviour for these.

  def cldr_data
    File.read("#{Cldr::Export::Data::RAW_DATA.directory}/main/de.xml")
  end

  test "filters file by draft status" do
    unconfirmed_count = pairs(Cldr::Export::DataFile.parse(cldr_data, minimum_draft_status: Cldr::DraftStatus::UNCONFIRMED)).count
    provisional_count = pairs(Cldr::Export::DataFile.parse(cldr_data, minimum_draft_status: Cldr::DraftStatus::PROVISIONAL)).count
    contributed_count = pairs(Cldr::Export::DataFile.parse(cldr_data, minimum_draft_status: Cldr::DraftStatus::CONTRIBUTED)).count
    approved_count = pairs(Cldr::Export::DataFile.parse(cldr_data, minimum_draft_status: Cldr::DraftStatus::APPROVED)).count

    assert(unconfirmed_count >= provisional_count, "Found #{unconfirmed_count} unconfirmed pairs, and #{provisional_count} provisional pairs")
    assert(provisional_count >= contributed_count, "Found #{provisional_count} provisional pairs, and #{contributed_count} contributed pairs")
    assert(contributed_count >= approved_count, "Found #{contributed_count} contributed pairs, and #{approved_count} approved pairs")
  end

  test "removes draft pairs and empty ancestors" do
    xml_contents = <<~XML_CONTENTS
      <?xml version="1.0" encoding="UTF-8" ?>
      <ldml>
        <identity>
          <version number="$Revision: 14491 $"/>
          <language type="de"/>
        </identity>
        <fields>
          <field type="quarter-narrow">
            <relative type="-1" draft="unconfirmed">letztes Quartal</relative>
            <relative type="0" draft="unconfirmed">dieses Quartal</relative>
            <relative type="1" draft="unconfirmed">nächstes Quartal</relative>
            <relativeTime type="future">
              <relativeTimePattern draft="provisional" count="one">in {0} Q</relativeTimePattern>
              <relativeTimePattern draft="provisional" count="other">in {0} Q</relativeTimePattern>
            </relativeTime>
            <relativeTime type="past">
              <relativeTimePattern draft="contributed" count="one">vor {0} Q</relativeTimePattern>
              <relativeTimePattern draft="contributed" count="other">vor {0} Q</relativeTimePattern>
            </relativeTime>
          </field>
        </fields>
      </ldml>
    XML_CONTENTS

    parsed = Cldr::Export::DataFile.parse(xml_contents, minimum_draft_status: Cldr::DraftStatus::APPROVED)

    expected = <<~XML_CONTENTS
      <?xml version="1.0" encoding="UTF-8"?>
      <ldml>
        <identity>
          <version number="$Revision: 14491 $"/>
          <language type="de"/>
        </identity>
      </ldml>
    XML_CONTENTS
    assert_equal(expected, parsed.doc.to_xml)
  end

  private

  def pairs(doc)
    return to_enum(:pairs, doc) unless block_given?

    doc.traverse do |node|
      next unless node.text?

      yield node.path, node.text
    end
  end
end
