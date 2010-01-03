require 'core_ext/string/underscore'
require 'core_ext/hash/deep_merge'
require 'nokogiri'

class Cldr
  module Data
    class Base < Hash
      attr_reader :locale

      def initialize(*args)
        hash    = args.last.is_a?(Hash) ? args.pop : {}
        @locale = args.pop.to_sym unless args.empty?
      end

      def []=(keys, value)
        return if value.nil? || value.respond_to?(:empty?) && value.empty?

        keys = keys.to_s.split('.')
        last_key = keys.pop.to_sym

        target = keys.inject(self) { |target, key| target[key.to_sym] || target.store(key.to_sym, {}) }
        target.store(last_key, value)
      end
      
      def update(hash)
        hash.each { |key, value| self[key] = value }
      end

      protected

        def plural?(node)
          !!node.attribute('count')
        end

        def draft?(node)
          draft = node.attribute('draft')
          draft && draft.value == 'unconfirmed'
        end

        def name(node)
          node.name.underscore
        end

        def count(node)
          node.attribute('count').value
        end

        def select(*sources)
          doc.xpath(xpath(sources))
        end
        
        def xpath(sources)
          path = sources.map { |source| source.respond_to?(:path) ? source.path : source }.join('/')
          path =~ /^\/?\/ldml/ ? path : "//ldml/#{path}"
        end

        def doc
          @doc ||= Nokogiri::XML(File.read(path))
        end

        def path
          @path ||= "#{Cldr::Data.dir}/main/#{locale}.xml"
        end
    end
  end
end