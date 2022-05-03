# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), "test_helper"))

class TestExport < Test::Unit::TestCase
  test "statuses can be compared" do
    assert(Cldr::DraftStatus::UNCONFIRMED < Cldr::DraftStatus::PROVISIONAL)
    assert(Cldr::DraftStatus::PROVISIONAL < Cldr::DraftStatus::CONTRIBUTED)
    assert(Cldr::DraftStatus::CONTRIBUTED < Cldr::DraftStatus::APPROVED)
  end

  test "statuses can be looked up by name" do
    assert_equal(Cldr::DraftStatus::UNCONFIRMED, Cldr::DraftStatus.fetch("unconfirmed"))
    assert_equal(Cldr::DraftStatus::PROVISIONAL, Cldr::DraftStatus.fetch("provisional"))
    assert_equal(Cldr::DraftStatus::CONTRIBUTED, Cldr::DraftStatus.fetch("contributed"))
    assert_equal(Cldr::DraftStatus::APPROVED, Cldr::DraftStatus.fetch("approved"))
  end

  test "statuses can be looked up by symbolic name" do
    assert_equal(Cldr::DraftStatus::UNCONFIRMED, Cldr::DraftStatus.fetch(:unconfirmed))
    assert_equal(Cldr::DraftStatus::PROVISIONAL, Cldr::DraftStatus.fetch(:provisional))
    assert_equal(Cldr::DraftStatus::CONTRIBUTED, Cldr::DraftStatus.fetch(:contributed))
    assert_equal(Cldr::DraftStatus::APPROVED, Cldr::DraftStatus.fetch(:approved))
  end

  test "statuses can be looked up by themselves" do
    assert_equal(Cldr::DraftStatus::UNCONFIRMED, Cldr::DraftStatus.fetch(Cldr::DraftStatus::UNCONFIRMED))
    assert_equal(Cldr::DraftStatus::PROVISIONAL, Cldr::DraftStatus.fetch(Cldr::DraftStatus::PROVISIONAL))
    assert_equal(Cldr::DraftStatus::CONTRIBUTED, Cldr::DraftStatus.fetch(Cldr::DraftStatus::CONTRIBUTED))
    assert_equal(Cldr::DraftStatus::APPROVED, Cldr::DraftStatus.fetch(Cldr::DraftStatus::APPROVED))
  end

  test "invalid statuses are not found" do
    assert_raises(KeyError) { Cldr::DraftStatus.fetch(:invalid) }
  end

  test "statuses are their own class" do
    Cldr::DraftStatus::ALL.each do |status|
      assert_instance_of(Cldr::DraftStatus::Status, status)
    end
  end
end
