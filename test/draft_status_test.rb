# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), "test_helper"))

class TestExport < Test::Unit::TestCase
  def test_statuses_can_be_compared
    assert(Cldr::DraftStatus::UNCONFIRMED < Cldr::DraftStatus::PROVISIONAL)
    assert(Cldr::DraftStatus::PROVISIONAL < Cldr::DraftStatus::CONTRIBUTED)
    assert(Cldr::DraftStatus::CONTRIBUTED < Cldr::DraftStatus::APPROVED)
  end

  def test_statuses_can_be_looked_up_by_name
    assert_equal(Cldr::DraftStatus::UNCONFIRMED, Cldr::DraftStatus.fetch("unconfirmed"))
    assert_equal(Cldr::DraftStatus::PROVISIONAL, Cldr::DraftStatus.fetch("provisional"))
    assert_equal(Cldr::DraftStatus::CONTRIBUTED, Cldr::DraftStatus.fetch("contributed"))
    assert_equal(Cldr::DraftStatus::APPROVED, Cldr::DraftStatus.fetch("approved"))
  end

  def test_statuses_can_be_looked_up_by_symbolic_name
    assert_equal(Cldr::DraftStatus::UNCONFIRMED, Cldr::DraftStatus.fetch(:unconfirmed))
    assert_equal(Cldr::DraftStatus::PROVISIONAL, Cldr::DraftStatus.fetch(:provisional))
    assert_equal(Cldr::DraftStatus::CONTRIBUTED, Cldr::DraftStatus.fetch(:contributed))
    assert_equal(Cldr::DraftStatus::APPROVED, Cldr::DraftStatus.fetch(:approved))
  end

  def test_statuses_can_be_looked_up_by_themselves
    assert_equal(Cldr::DraftStatus::UNCONFIRMED, Cldr::DraftStatus.fetch(Cldr::DraftStatus::UNCONFIRMED))
    assert_equal(Cldr::DraftStatus::PROVISIONAL, Cldr::DraftStatus.fetch(Cldr::DraftStatus::PROVISIONAL))
    assert_equal(Cldr::DraftStatus::CONTRIBUTED, Cldr::DraftStatus.fetch(Cldr::DraftStatus::CONTRIBUTED))
    assert_equal(Cldr::DraftStatus::APPROVED, Cldr::DraftStatus.fetch(Cldr::DraftStatus::APPROVED))
  end

  def test_invalid_statuses_are_not_found
    assert_raises(KeyError) { Cldr::DraftStatus.fetch(:invalid) }
  end

  def test_statuses_are_their_own_class
    Cldr::DraftStatus::ALL.each do |status|
      assert_instance_of(Cldr::DraftStatus::Status, status)
    end
  end
end
