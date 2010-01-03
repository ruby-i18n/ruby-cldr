# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper.rb'
require 'core_ext/hash/deep_stringify_keys'

class TestCldrDataCalendars < Test::Unit::TestCase
  def gregorian(locale = :de)
    Cldr::Data::Calendars.new(locale)[:calendars][:gregorian]
  end

  define_method 'test: calendars months :de' do
    months = {
      :default => :format,
      :format  => {
        :default     => :wide,
        :wide        => { 1 => 'Januar', 2 => 'Februar', 3 => 'März', 4 => 'April', 5 => 'Mai', 6 => 'Juni', 7 => 'Juli', 8 => 'August', 9 => 'September', 10 => 'Oktober', 11 => 'November', 12 => 'Dezember' },
        :abbreviated => { 1 => 'Jan', 2 => 'Feb', 3 => 'Mär', 4 => 'Apr', 5 => 'Mai', 6 => 'Jun', 7 => 'Jul', 8 => 'Aug', 9 => 'Sep', 10 => 'Okt', 11 => 'Nov', 12 => 'Dez' }
      },
      :'stand-alone' => {
        :default     => :wide,
        # HU? why's all the rest missing in cldr data??
        :abbreviated => { 3 => 'Mär', 7 => 'Jul', 8 => 'Aug', 9 => 'Sep', 10 => 'Okt', 11 => 'Nov', 12 => 'Dez' },
        :narrow      => { 1 => 'J', 2 => 'F', 3 => 'M', 4 => 'A', 5 => 'M', 6 => 'J', 7 => 'J', 8 => 'A', 9 => 'S', 10 => 'O', 11 => 'N', 12 => 'D' }
      }
    }
    
    assert_equal months, gregorian[:months]
  end
  
  define_method 'test: calendars days :de' do
    days = {
      :default => :format,
      :format  => {
        :default     => :wide,
        :wide        => { :sun => 'Sonntag', :mon => 'Montag', :tue => 'Dienstag', :wed => 'Mittwoch', :thu => 'Donnerstag', :fri => 'Freitag', :sat => 'Samstag' },
        :abbreviated => { :sun => 'So.', :mon => 'Mo.', :tue => 'Di.', :wed => 'Mi.', :thu => 'Do.', :fri => 'Fr.', :sat => 'Sa.' }
      },
      :'stand-alone' => {
        :default     => :wide,
        :narrow      => { :sun => 'S', :mon => 'M', :tue => 'D', :wed => 'M', :thu => 'D', :fri => 'F', :sat => 'S' }
      }
    }
    assert_equal days, gregorian[:days]
  end
  
  define_method 'test: calendars quarters :de' do
    quarters = {
      :default => :format,
      :format  => {
        :default     => :wide,
        :wide        => { 1 => "1. Quartal", 2 => "2. Quartal", 3 => "3. Quartal", 4 => "4. Quartal" },
        :abbreviated => { 1 => "Q1", 2 => "Q2", 3 => "Q3", 4 => "Q4" }
      },
      :"stand-alone" => {
        :default => :wide, 
        :narrow  => { 1 => "1", 2 => "2", 3 => "3", 4 => "4" }
      }
    }
    assert_equal quarters, gregorian[:quarters]
  end
  
  define_method 'test: calendars day_periods :de' do
    day_periods = {
      :am => 'vorm.',
      :pm => 'nachm.',
    }
    assert_equal day_periods, gregorian[:day_periods]
  end
  
  # define_method 'test: calendars eras :de' do
  #   eras = {
  #     0 => { :abbr => "v. Chr.", :name => "v. Chr." },
  #     1 => { :abbr => "n. Chr.", :name => "n. Chr." }
  #   }
  #   assert_equal eras, gregorian[:eras]
  # end
  
  define_method 'test: calendars date formats :de' do
    formats = {
      :full    => { :pattern => "EEEE, d. MMMM yyyy" },
      :long    => { :pattern => "d. MMMM yyyy" },
      :medium  => { :pattern => "dd.MM.yyyy" },
      :short   => { :pattern => "dd.MM.yy" },
      :default => :medium
    }
    assert_equal formats, gregorian[:formats][:date]
  end
  
  define_method 'test: calendars time formats :de' do
    formats = {
      :full    => { :pattern => "HH:mm:ss v" },
      :long    => { :pattern => "HH:mm:ss z" },
      :medium  => { :pattern => "HH:mm:ss" },
      :short   => { :pattern => "HH:mm" },
      :default => :medium
    }
    assert_equal formats, gregorian[:formats][:time]
  end
  
  define_method 'test: calendars datetime formats :de' do
    formats = {
      :format  => { :pattern => "{1} {0}"}
    }
    assert_equal formats, gregorian[:formats][:datetime]
  end
  
  define_method 'test: calendars fields :de' do
    fields = {
      :hour      => "Stunde",
      :minute    => "Minute",
      :second    => "Sekunde",
      :day       => "Tag",
      :month     => "Monat",
      :year      => "Jahr",
      :week      => "Woche",
      :weekday   => "Wochentag",
      :dayperiod => "Tageshälfte",
      :era       => "Epoche",
      :zone      => "Zone"
    }
    assert_equal fields, gregorian[:fields]
  end
  
  Cldr::Data.locales.each do |locale|
    define_method "test: extract calendars for #{locale}" do
      Cldr::Data::Calendars.new(locale)
    end
  end
end