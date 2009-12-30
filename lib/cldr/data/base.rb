require 'core_ext/string/underscore'
require 'core_ext/hash/deep_merge'
require 'nokogiri'

module Cldr
  module Data
    class Base
      attr_reader :locale
      
      def initialize(locale)
        @locale = locale
      end

      protected
      
        def extract(map, options = {})
          map.inject({}) do |result, (source, target)|
            nodes = select(source)
            value = source =~ /\*$/ ? extract_hash(nodes, options) : extract_value(nodes, options)
            result.deep_merge(wrap(target, value))
          end
        end
    
        def extract_hash(nodes, options = {})
          read_key   = options[:key]   || lambda { |node| name(node).to_sym }
          read_value = options[:value] || lambda { |node| node.content }

          nodes.inject({}) do |result, node|
            key, value  = read_key.call(node), read_value.call(node)
            key, value  = key.shift, wrap(key, value) if key.is_a?(Array)
            result[key] = value unless result[key] && draft?(node)
            result
          end
        end
    
        def extract_value(nodes, options = {})
          if plural?(nodes.first)
            extract_plurals(nodes)
          else
            nodes.detect { |node| !draft?(node) }.content
          end
        end
    
        def extract_plurals(nodes)
          extract_hash(nodes, :key => lambda { |node| count(node) })
        end
    
        def wrap(target, result)
          keys = Array(target).map { |key| key.to_s.split('/') }.flatten
          keys.reverse.inject(result) { |result, key| { key.to_sym => result } }
        end
    
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
    
        def select(source)
          doc.xpath("//ldml/#{source}")
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