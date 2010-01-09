require 'fileutils'
require 'net/http'
require 'uri'
require 'tempfile'

class Cldr
  class << self
    def download(source = nil, target = nil)
      source ||= 'http://unicode.org/Public/cldr/1.7.2/core.zip'
      target ||= File.expand_path('./vendor/cldr')

      source = URI.parse(source)
      tempfile = Tempfile.new('cldr-core')

      Net::HTTP.start(source.host) do |http|
        response = http.get(source.path)
        File.open(tempfile, "wb") { |f| f.write(response.body) }
      end
      
      FileUtils.mkdir_p(target)
      `unzip #{tempfile.path} -d #{target}`

      puts "extracted #{source} to #{target}"
    end
  end
end