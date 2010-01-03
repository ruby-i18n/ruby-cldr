require 'fileutils'
require 'core_ext/string/camelize'
require 'core_ext/string/underscore'
require 'core_ext/hash/deep_stringify_keys'

module Cldr
  module Data
    module Export
      autoload :Yaml, 'cldr/data/export/yaml'
      
      class << self
        def base_path
          @@base_path ||= File.expand_path(File.dirname(__FILE__) + '/../../../data')
        end

        def base_path=(base_path)
          @@base_path = base_path
        end
        
        def data(component, locale)
          data = Data.const_get(component.to_s.camelize).new(locale).to_hash
          data.deep_stringify_keys unless data.nil? || data.empty?
        end
        
        def write(component, locale, data)
          path = path(locale, component)
          FileUtils.rm(path) if File.exists?(path)
          FileUtils.mkdir_p(File.dirname(path))
          File.open(path, 'w+') { |f| f.write(data) }
          path
        end
      
        def path(locale, component)
          "#{Export.base_path}/#{locale}/#{component.to_s.underscore}.yml"
        end
      end
    end
  end
end