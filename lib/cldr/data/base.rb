require 'core_ext/string/underscore'
require 'core_ext/hash/deep_merge'
require 'nokogiri'

module Cldr
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

        # def extract(map, options = {})
        #   map.inject({}) do |result, (source, target)|
        #     nodes = select(source)
        #     value = source =~ /\*$/ ? extract_hash(nodes, options) : extract_value(nodes, options)
        #     value ? result.deep_merge(wrap(target, value)) : result
        #   end
        # end
        # 
        # def extract_hash(nodes, options = {})
        #   read_key   = options[:key]   || lambda { |node| name(node).to_sym }
        #   read_value = options[:value] || lambda { |node| node.content }
        # 
        #   nodes.inject({}) do |result, node|
        #     key, value  = read_key.call(node), read_value.call(node)
        #     key, value  = key.shift, wrap(key, value) if key.is_a?(Array)
        #     result[key] = value unless result[key] && draft?(node)
        #     result
        #   end
        # end
        # 
        # def extract_value(nodes, options = {})
        #   if nodes.empty?
        #     nil
        #   elsif plural?(nodes.first)
        #     extract_plurals(nodes)
        #   else
        #     nodes.detect { |node| !draft?(node) }.content rescue nil
        #   end
        # end
        # 
        # def extract_plurals(nodes)
        #   extract_hash(nodes, :key => lambda { |node| count(node) })
        # end
        # 
        # def wrap(target, result)
        #   keys = Array(target).map { |key| key.to_s.split('/') }.flatten
        #   keys.reverse.inject(result) { |result, key| { key.to_sym => result } }
        # end

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
          @path ||= "#{Cldr::Data.dir}/#{locale}.xml"
        end
    end
  end
end