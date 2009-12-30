# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper.rb'

class TestCldrDataUnits < Test::Unit::TestCase
  define_method 'test: units' do
    expected = {
      :units => {
        :day    => { :one => "{0} Tag",     :other => "{0} Tage" },
        :week   => { :one => "{0} Woche",   :other => "{0} Wochen" },
        :month  => { :one => "{0} Monat",   :other => "{0} Monate" },
        :year   => { :one => "{0} Jahr",    :other => "{0} Jahre" },
        :hour   => { :one => "{0} Stunde",  :other => "{0} Stunden" },
        :minute => { :one => "{0} Minute",  :other => "{0} Minuten" },
        :second => { :one => "{0} Sekunde", :other => "{0} Sekunden" }
      }
    }
    assert_equal expected, Cldr::Data::Units.new('de').data
  end
end