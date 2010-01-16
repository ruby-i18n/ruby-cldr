require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "ruby-cldr"
    gem.summary = %Q{Ruby library for exporting and using data from CLDR }
    gem.description = %Q{Ruby library for exporting and using data from CLDR, see http://cldr.unicode.org}
    gem.email = "svenfuchs@artweb-design.de"
    gem.homepage = "http://github.com/svenfuchs/ruby-cldr"
    gem.authors = ["Sven Fuchs"]
    gem.files =  FileList["*.thor", "[A-Z]*", "{lib,test}/**/*"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end