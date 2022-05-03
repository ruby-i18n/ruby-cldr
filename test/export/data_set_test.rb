# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../test_helper"))

class TestDataSet < Test::Unit::TestCase
  class DummyDataSet < Cldr::Export::DataSet
    private

    def compute(locale)
      locale == :missing ? nil : parent[locale] * 2
    end

    def locales_at_this_level
      (parent&.locales || []).map { |l| (l.to_s * 2).to_sym }
    end
  end

  test "Uses provided values in preference to parent values" do
    parent_data_set = DummyDataSet.new
    data_set = DummyDataSet.new(parent: parent_data_set)

    parent_data_set[:de] = "de from parent"
    data_set[:de] = "de"

    assert_equal("de", data_set[:de])
  end

  test "Computes based on parent values" do
    parent_data_set = DummyDataSet.new
    parent_data_set[:de] = "de"

    data_set = DummyDataSet.new(parent: parent_data_set)
    assert_equal("dede", data_set[:de])
  end

  test "locales includes the locales of parents" do
    parent_data_set = DummyDataSet.new
    parent_data_set[:de] = "de"
    parent_data_set[:en] = "de"

    data_set = DummyDataSet.new(parent: parent_data_set)
    parent_data_set[:es] = "es"

    assert_equal([:de, :dede, :en, :enen, :es, :eses], data_set.locales)
  end
end
