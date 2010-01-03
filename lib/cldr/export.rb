require 'fileutils'
require 'core_ext/string/camelize'
require 'core_ext/string/underscore'
require 'core_ext/hash/deep_stringify_keys'

class Cldr
  module Export
    autoload :Ruby, 'cldr/export/ruby'
    autoload :Yaml, 'cldr/export/yaml'
    
    class << self
      def base_path
        @@base_path ||= File.expand_path(File.dirname(__FILE__) + '/../../data')
      end

      def base_path=(base_path)
        @@base_path = base_path
      end

      def export(options = {}, &block)
        format     = options[:format]
        locales    = options[:locales]    || Data.locales
        components = options[:components] || Data.components

        locales.each do |locale|
          components.each do |component|
            exporter(component, format).export(locale, component, &block)
          end
        end
      end
      
      def exporter(component, format)
        name = format ? format : component.to_s == 'Plurals' ? 'ruby' : 'yaml'
        const_get(name.to_s.camelize).new
      end
      
      def data(component, locale)
        Data.const_get(component.to_s.camelize).new(locale)
      end
      
      def write(path, data)
        FileUtils.rm(path) if File.exists?(path)
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, 'w+') { |f| f.write(data) }
      end
    
      def path(locale, component, extension)
        "#{Export.base_path}/#{locale.gsub('_', '-')}/#{component.to_s.underscore}.#{extension}"
      end
    end
  end
end