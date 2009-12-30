# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper.rb'

class TestCldrDataDelimiters < Test::Unit::TestCase
  define_method 'test: delimiters :de' do
    expected = {
      :delimiters => {
        :quotes => {
          :default => {
            :start => '„',
            :end   => '“'
          },
          :alternate => {
            :start => '‚',
            :end   => '‘'
          }
        }
      }
    }
    assert_equal expected, Cldr::Data::Delimiters.new('de').data
  end

  Cldr::Data.locales.each do |locale|
    define_method "test: extract delimiters for #{locale}" do
      Cldr::Data::Delimiters.new(locale).data
    end
  end
end