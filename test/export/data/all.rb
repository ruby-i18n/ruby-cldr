Dir["#{File.dirname(__FILE__)}/**/*_test.rb"].each do |filename|
  require File.expand_path(filename)
end