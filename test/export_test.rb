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

  test "writes dot-separated symbols to yaml" do
    data = { :format  => { :narrow => :"calendars.gregorian.months.stand-alone.narrow" } }
    yaml = %(\nformat: \n  narrow: :"calendars.gregorian.months.stand-alone.narrow")

    assert_equal yaml, Cldr::Export::Yaml.new.emit(data.deep_stringify_keys)
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