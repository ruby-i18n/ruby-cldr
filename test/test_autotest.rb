# frozen_string_literal: true

def tests_for(filename)
  pattern = case filename
  when /gregorian\.rb/
    "test/export/data/calendars_test.rb"
  when %r(/base.rb)
    dir  = filename.gsub("/base.rb", "")
    base = File.basename(dir)
    dir  = File.dirname(dir).gsub(%(lib/cldr), "")
    "test/#{dir}/{#{base},#{base}/**/*}_test.rb"
  when %r(lib/cldr/.*\.rb)
    "test/" + filename.gsub("lib/cldr/", "").gsub(/\.rb$/, "_test.rb")
  when %r(^test/.*_test\.rb)
    filename
  end
  pattern ? Dir[pattern.gsub("//", "/")] : []
end

if $PROGRAM_NAME == __FILE__
  require "test/unit"

  class TestAutotestMatching < Test::Unit::TestCase
    define_method test_default_mapping_for_library_files do
      assert tests_for("lib/cldr/format/date.rb").all? { |file| file =~ /date_test.rb/ }
      assert tests_for("lib/cldr/format/decimal/fraction.rb").all? { |file| file =~ /fraction_test.rb/ }
      assert tests_for("lib/cldr/format/decimal/base.rb").all? { |file| file =~ /decimal/ }
    end

    define_method test_mapping_for_gregorian_rb do
      assert_equal ["test/export/data/calendars_test.rb"], tests_for("lib/cldr/calendars/gregorian.rb")
    end

    define_method test_default_mapping_for_test_files do
      assert_equal ["test/export_test.rb"], tests_for("test/export_test.rb")
    end
  end
end
