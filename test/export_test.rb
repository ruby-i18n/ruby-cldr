# encoding: utf-8

require File.dirname(__FILE__) + '/test_helper.rb'
require 'yaml'
require 'fileutils'

class TestExtract < Test::Unit::TestCase
  def setup
    Cldr::Export.base_path = tmp_dir
    FileUtils.mkdir_p(tmp_dir) rescue nil
  end

  def teardown
    FileUtils.rm_r(tmp_dir)
  end

  def tmp_dir
    File.expand_path(File.dirname(__FILE__) + '/tmp')
  end

  test 'passing the merge option generates and merge data for all fallback locales' do
    data = Cldr::Export.data('numbers', 'de-AT')
    assert !data[:numbers][:formats][:nan]

    data = Cldr::Export.data('numbers', 'de-AT', :merge => true)
    assert_equal 'NaN', data[:numbers][:symbols][:nan]
  end

  test 'the merge option respects parentLocales' do
    data = Cldr::Export.data('calendars', 'en-GB', :merge => true)
    assert_equal 'dd/MM/y', data[:calendars][:gregorian][:additional_formats]['yMd']
  end

  test "exports data to files" do
    Cldr::Export.export(:locales => %w(de), :components => %w(calendars))
    assert File.exists?(Cldr::Export.path('de', 'calendars', 'yml'))
  end

  test "exported data starts with the locale at top level" do
    Cldr::Export.export(:locales => %w(de), :components => %w(calendars))
    data = {}
    File.open(Cldr::Export.path('de', 'calendars', 'yml')) do |f|
      data = YAML.load(f)
    end
    assert data['de']
  end

  test "writes dot-separated symbols to yaml in a way that can be loaded back" do
    data = { 'format'  => { 'narrow' => :"calendars.gregorian.months.stand-alone.narrow" } }
    yaml = Cldr::Export::Yaml.new.yaml(data.deep_stringify_keys)

    assert_equal data, YAML.load(yaml)
  end

  test "escapes data in a way that can be properly loaded back" do
    data = ['017', '017b', '019', '0', '1', 'AAA', 1, 101]
    yaml = Cldr::Export::Yaml.new.yaml(data)
    new_data = YAML.load(yaml)

    assert_equal data, new_data
  end

  test "escapes keys in a way that can be properly parsed back" do
    data = {
      '017' =>17,
      15 => 9,
      9 =>'009',
    }
    yaml = Cldr::Export::Yaml.new.yaml(data)
    new_data = YAML.load(yaml)

    assert_equal data, new_data
  end

  test "#locales does not fall back to English (unless the locale is English based)" do
    assert_equal [:ko, :root], Cldr::Export.locales('ko', 'numbers', :merge => true)
    assert_equal [:'pt-br', :pt, :root], Cldr::Export.locales('pt-br', 'numbers', :merge => true)
    assert_equal [:'en-gb', :en, :root], Cldr::Export.locales('en-gb', 'numbers', :merge => true)
  end

  test "#locales does not fall back if :merge option is false" do
    assert_equal [:'pt-br', :root], Cldr::Export.locales('pt-br', 'numbers', :merge => false)
  end

  # Cldr::Export::Data.locales.each do |locale|
  #   Cldr::Export::Data.components.each do |component|
  #     test "exported yaml file yaml for #{locale}/#{component} readable" do
  #       Cldr::Export.export(:locales => [locale], :components => [component])
  #       assert_nothing_raised do
  #         YAML.load(File.open(Cldr::Export::Data::Export.path(locale, component))) rescue Errno::ENOENT
  #       end
  #     end
  #   end
  # end
end
