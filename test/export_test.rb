# encoding: utf-8
# frozen_string_literal: true

require "yaml"
require "fileutils"

require File.expand_path(File.join(File.dirname(__FILE__), "test_helper"))

class TestExport < Test::Unit::TestCase
  def setup
    Cldr::Export.base_path = tmp_dir
    Cldr::Export.minimum_draft_status = Cldr::DraftStatus::CONTRIBUTED
    begin
      FileUtils.mkdir_p(tmp_dir)
    rescue
      nil
    end
  end

  def teardown
    FileUtils.rm_r(tmp_dir)
  end

  def tmp_dir
    File.expand_path(File.dirname(__FILE__) + "/tmp")
  end

  test "passing the merge option generates and merge data for all fallback locales" do
    data = Cldr::Export.data(:Numbers, :"de-AT")
    assert !data[:numbers][:formats][:nan]

    data = Cldr::Export.data(:Numbers, :"de-AT", merge: true)
    assert_equal "NaN", data[:numbers][:symbols][:nan]
  end

  test "passing the merge option generates and merges Plurals data from fallback locales" do
    data = Cldr::Export.data(:Plurals, :"af-NA")
    assert_nil(data)

    data = Cldr::Export.data(:Plurals, :"af-NA", merge: true)
    assert_equal([:"af-NA"], data.keys)
  end

  test "the merge option respects parentLocales" do
    data = Cldr::Export.data(:Calendars, :"en-GB", merge: true)
    assert_equal "dd/MM/y", data[:calendars][:gregorian][:additional_formats]["yMd"]
  end

  test "exports data to files" do
    Cldr::Export.export(locales: [:de], components: [:Calendars])
    assert File.exist?(Cldr::Export.path("de", "calendars", "yml"))
  end

  test "exported data starts with the locale at top level" do
    Cldr::Export.export(locales: [:de], components: [:Calendars])
    data = {}
    File.open(Cldr::Export.path("de", "calendars", "yml")) do |f|
      data = YAML.load(f)
    end
    assert data["de"]
  end

  test "#locales does not fall back to English (unless the locale is English based)" do
    assert_equal [:ko, :root], Cldr::Export.locales(:ko, "numbers", merge: true)
    assert_equal [:"pt-BR", :pt, :root], Cldr::Export.locales(:"pt-BR", "numbers", merge: true)
    assert_equal [:"en-GB", :"en-001", :en, :root], Cldr::Export.locales(:"en-GB", "numbers", merge: true)
  end

  test "#locales does not fall back if :merge option is false" do
    assert_equal [:"pt-BR"], Cldr::Export.locales(:"pt-BR", "numbers", merge: false)
  end
end
