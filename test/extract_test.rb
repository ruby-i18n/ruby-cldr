require File.dirname(__FILE__) + '/test_helper.rb'
require 'pp'

class TestCldrExtractorParser < Test::Unit::TestCase
  define_method "test: number_symbols" do
    data = Cldr::Data.number_symbols('de')
    assert data.key?(:numbers)
    assert data[:numbers].key?(:symbols)
    
    keys = data[:numbers][:symbols].keys
    values = data[:numbers][:symbols].values
    assert_equal 5, ([:decimal, :group, :plus_sign, :minus_sign, :percent_sign] & keys).size
    assert_equal 5, (%w(, . + - %) & values).size
  end
  
  define_method "test: number_formats" do
    data = Cldr::Data.number_formats('de')
    assert data.key?(:numbers)
    assert data[:numbers].key?(:formats)
  
    keys = data[:numbers][:formats].keys
    values = data[:numbers][:formats].values.map { |h| h[:pattern] }
    assert_equal 4, ([:decimal, :percent, :scientific, :currency] & keys).size
    assert_equal 4, (['#,##0.###', '#,##0 %', '#E0', '#,##0.00 ¤'] & values).size
  end
  
  define_method "test: delimiters" do
    data = Cldr::Data.delimiters('de')

    assert data.key?(:delimiters)
    assert data[:delimiters].key?(:quotes)
    assert data[:delimiters][:quotes].key?(:default)
    assert data[:delimiters][:quotes].key?(:alternate)
  
    keys = data[:delimiters][:quotes][:default].keys
    values = data[:delimiters][:quotes][:default].values
    assert_equal 2, ([:start, :end] & keys).size
    assert_equal 2, (['„', '“'] & values).size
  
    keys = data[:delimiters][:quotes][:alternate].keys
    values = data[:delimiters][:quotes][:alternate].values
    assert_equal 2, ([:start, :end] & keys).size
    assert_equal 2, (['‚', '‘'] & values).size
  end

  define_method "test: languages" do
    data = Cldr::Data.languages('de')
    p data
    assert data.key?(:languages)
    assert data[:languages].key?(:de)
    assert_equal({ :locale => :de, :name => 'Deutsch' }, data[:languages][:de])
  end
  
  define_method "test: territories" do
    data = Cldr::Data.territories('de')
    assert data.key?(:territories)
    assert data[:territories].key?(:'057')
    assert_equal({ :code => :'057', :name => 'Mikronesisches Inselgebiet' }, data[:territories][:'057'])
  end
  
  # define_method "test: calendars" do
  #   data = Cldr::Data.calendars('de')
  # end
end