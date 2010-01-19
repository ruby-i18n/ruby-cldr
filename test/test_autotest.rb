def tests_for(filename)
  pattern = case filename
  when %r(/base.rb)
    dir  = filename.gsub('/base.rb', '')
    base = File.basename(dir)
    dir  = File.dirname(dir).gsub(%(lib/cldr), '')
    "test/#{dir}/{#{base},#{base}/**/*}_test.rb"
  when %r(lib/cldr/.*\.rb)
    "test/" + filename.gsub('lib/cldr/', '').gsub(/\.rb/, '_test.rb')
  end
  pattern ? Dir[pattern.gsub('//', '/')] : []
end

if $0 == __FILE__
  require 'test/unit'
  
  class TestAutotestMatching < Test::Unit::TestCase
    define_method :"test: works" do
      assert tests_for("lib/cldr/format/date.rb").all? { |file| file =~ /date_test.rb/ }
      assert tests_for("lib/cldr/format/decimal/fraction.rb").all? { |file| file =~ /fraction_test.rb/ }
      assert tests_for("lib/cldr/format/decimal/base.rb").all? { |file| file =~ /decimal/ }
    end
  end
end