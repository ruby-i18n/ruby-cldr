# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../test_helper"))

class TestResolver < Test::Unit::TestCase
  def setup
    Cldr::Export.minimum_draft_status = Cldr::DraftStatus::CONTRIBUTED
    @test_data_set = Cldr::Export::FileBasedDataSet.new(directory: File.expand_path("./test/fixtures/cldr/common"))
  end

  test "#resolve_value complains when the path matches multiple nodes" do
    locale = :de
    path = "/ldml/units/unitLength[@type='long']/unit"
    exc = assert_raise(Cldr::Export::Resolver::AmbiguousPathError) do
      @test_data_set.send(:resolve_value, locale, path)
    end
    assert_equal "Path `#{path}` is not specific enough. Found 2 matches", exc.message
  end

  test "resolve_value resolves by falling back" do
    locale = :"en-CH"
    path = "/ldml/dates/timeZoneNames/zone[@type='America/St_Barthelemy']/exemplarCity"
    result = @test_data_set.send(:resolve_value, locale, path)
    assert_equal("St Barthélemy", result.children.first.text)
    assert_equal(:"en-001", result.locale)
  end

  test "resolve_value stops falling back when it finds the empty override" do
    locale = :"en-001"
    path = "/ldml/dates/timeZoneNames/zone[@type='Pacific/Honolulu']/short/generic"
    assert_nil(@test_data_set.send(:resolve_value, locale, path))
  end

  test "#resolve_value resolves aliases for a specific element" do
    locale = :zh
    path = "/ldml/units/unitLength[@type='long']/unit[@type='mass-kilogram']/unitPattern[@count='other']"
    result = @test_data_set.send(:resolve_value, locale, path)
    assert_equal("{0} kg", result.children.first.text)
    assert_equal(:root, result.locale)
  end

  test "#resolve_value resolves aliases for a group" do
    locale = :de
    path = "/ldml/units/unitLength[@type='narrow']"
    result = @test_data_set.send(:resolve_value, locale, path)

    expected = <<~XML_CONTENTS
      <unit type="duration-year">
        <displayName>J</displayName>
        <unitPattern count="one">{0} J</unitPattern>
        <unitPattern count="other">{0} J</unitPattern>
        <perUnitPattern>{0}/J</perUnitPattern>
      </unit>
    XML_CONTENTS

    assert_equal(expected, result.children.first.to_xml + "\n")
    assert_equal(:de, result.locale)
  end

  test "#resolve_value resolves aliases, restarting from the original locale" do
    locale = :de
    path = "/ldml/units/unitLength[@type='long']/unit[@type='duration-year-person']/unitPattern[@count='other']"
    result = @test_data_set.send(:resolve_value, locale, path)
    assert_equal("{0} J", result.children.first.text)
    assert_equal(:de, result.locale)
  end

  test "#resolve_value works for normal values in root" do
    locale = :root
    path = "/ldml/units/unitLength[@type='short']/unit[@type='mass-kilogram']/unitPattern[@count='other']"
    result = @test_data_set.send(:resolve_value, locale, path)
    assert_equal("{0} kg", result.children.first.text)
    assert_equal(:root, result.locale)
  end

  test "#resolve_value returns nil if the value isn't in root and there isn't an alias" do
    locale = :root
    path = "/ldml/units/unitLength[@type='short']/unit[@type='mass-kilogram']/unitPattern[@count='few']"
    assert_nil(@test_data_set.send(:resolve_value, locale, path))
  end

  test "#chop_path works" do
    expected = [
      ["/ldml/units/unitLength[@type='long']/unit[@type='mass-kilogram']/unitPattern[@count='other']", ""],
      ["/ldml/units/unitLength[@type='long']/unit[@type='mass-kilogram']/unitPattern", ""],
      ["/ldml/units/unitLength[@type='long']/unit[@type='mass-kilogram']", "unitPattern[@count='other']"],
      ["/ldml/units/unitLength[@type='long']/unit", "unitPattern[@count='other']"],
      ["/ldml/units/unitLength[@type='long']", "unit[@type='mass-kilogram']/unitPattern[@count='other']"],
      ["/ldml/units/unitLength", "unit[@type='mass-kilogram']/unitPattern[@count='other']"],
      ["/ldml/units", "unitLength[@type='long']/unit[@type='mass-kilogram']/unitPattern[@count='other']"],
      ["/ldml", "units/unitLength[@type='long']/unit[@type='mass-kilogram']/unitPattern[@count='other']"],
      ["/", "ldml/units/unitLength[@type='long']/unit[@type='mass-kilogram']/unitPattern[@count='other']"],
    ]

    path = "/ldml/units/unitLength[@type='long']/unit[@type='mass-kilogram']/unitPattern[@count='other']"
    assert_equal(expected, @test_data_set.send(:chop_path, path).to_a)
  end

  test "#chop_path without strip_final_predicate" do
    expected = [
      ["/ldml/units/unitLength[@type='long']/unit[@type='mass-kilogram']/unitPattern[@count='other']", ""],
      ["/ldml/units/unitLength[@type='long']/unit[@type='mass-kilogram']", "unitPattern[@count='other']"],
      ["/ldml/units/unitLength[@type='long']", "unit[@type='mass-kilogram']/unitPattern[@count='other']"],
      ["/ldml/units", "unitLength[@type='long']/unit[@type='mass-kilogram']/unitPattern[@count='other']"],
      ["/ldml", "units/unitLength[@type='long']/unit[@type='mass-kilogram']/unitPattern[@count='other']"],
      ["/", "ldml/units/unitLength[@type='long']/unit[@type='mass-kilogram']/unitPattern[@count='other']"],
    ]

    path = "/ldml/units/unitLength[@type='long']/unit[@type='mass-kilogram']/unitPattern[@count='other']"
    assert_equal(expected, @test_data_set.send(:chop_path, path, strip_final_predicate: false).to_a)
  end

  test "#partitions works" do
    expected = [
      [[], [1, 2, 3]],
      [[1], [2, 3]],
      [[1, 2], [3]],
      [[1, 2, 3], []],
    ]
    assert_equal(expected, @test_data_set.send(:partitions, [1, 2, 3]).to_a)
  end

  test "#strip_predicates works" do
    path = "/ldml/units/unitLength[@type='long']/unit[@type='mass-kilogram']/unitPattern[@count='other']"
    expected = "/ldml/units/unitLength/unit/unitPattern"
    assert_equal(expected, @test_data_set.send(:strip_predicates, path))
  end
end
