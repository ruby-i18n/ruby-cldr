require 'fileutils'
require 'net/http'
require 'uri'
require 'tempfile'

module Cldr
  class << self
    def download(source = nil, target = nil)
      source ||= 'http://unicode.org/Public/cldr/24/core.zip'
      target ||= File.expand_path('./vendor/cldr')

      source = URI.parse(source)
      tempfile = Tempfile.new('cldr-core')

      system("curl #{source} -o #{tempfile.path}")
      FileUtils.mkdir_p(target)
      system("unzip #{tempfile.path} -d #{target}")
    end
  end
end