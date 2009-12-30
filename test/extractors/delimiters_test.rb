# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper.rb'

class TestCldrDataDelimiters < Test::Unit::TestCase
  define_method 'test: delimiters' do
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
end