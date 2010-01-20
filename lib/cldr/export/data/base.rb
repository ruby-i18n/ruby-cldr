require 'core_ext/string/underscore'
require 'core_ext/hash/deep_merge'
require 'nokogiri'

module Cldr
  module Export
    module Data
      class Base < Hash
        attr_reader :locale

        def initialize(locale)
          @locale = locale
        end
      
        def update(hash)
          hash.each { |key, value| self[key] = value }
        end

        def []=(key, value)
          store(key, value) unless value.nil? || value.respond_to?(:empty?) && value.empty?
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
            @path ||= "#{Cldr::Export::Data.dir}/main/#{locale.to_s.gsub('-', '_')}.xml"
          end
      end
    end
  end
end