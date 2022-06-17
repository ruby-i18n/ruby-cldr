# frozen_string_literal: true

require "core_ext/string/underscore"

module Cldr
  module Export
    module Data
      class Base < Hash
        attr_reader :locale

        def initialize(locale)
          super()
          @locale = locale
        end

        def update(hash)
          hash.each { |key, value| self[key] = value }
        end

        def []=(key, value)
          store(key, value) unless value.nil? || value.respond_to?(:empty?) && value.empty?
        end

        protected

        def alt?(node) # TODO: Move this into DataFile
          !node.attribute("alt").nil?
        end

        def name(node)
          node.name.underscore
        end

        def count(node)
          node.attribute("count").value
        end

        def select(*sources)
          doc.xpath(xpath(sources))
        end

        def xpath(sources)
          path = sources.map { |source| source.respond_to?(:path) ? source.path : source }.join("/")
          path =~ %r{^/?/ldml} ? path : "//ldml/#{path}"
        end

        def doc
          Cldr::Export::Data::RAW_DATA[locale]
        end
      end
    end
  end
end
