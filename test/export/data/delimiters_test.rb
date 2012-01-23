# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__) + '/../../test_helper'))

class TestCldrDataDelimiters < Test::Unit::TestCase
  test 'delimiters :de' do
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
    assert_equal expected, Cldr::Export::Data::Delimiters.new('de')
  end

  # Cldr::Export::Data.locales.each do |locale|
  #   test "extract delimiters for #{locale}" do
  #     assert_nothing_raised do
  #       Cldr::Export::Data::Delimiters.new(locale)
  #     end
  #   end
  # end
end