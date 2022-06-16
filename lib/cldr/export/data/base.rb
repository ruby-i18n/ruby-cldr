# frozen_string_literal: true

require "core_ext/string/underscore"
require "core_ext/hash/deep_merge"
require "nokogiri"

module Cldr
  module Export
    module Data
      class Base < Hash
        attr_reader :locale

        @@doc_cache = {}

        def initialize(locale)
          super()
          @locale = locale
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
          @@doc_cache[paths.hash] ||= merge_paths(paths)
        end

        def paths
          @paths ||= if locale
            Dir[File.join(Cldr::Export::Data.dir, "*", "#{Cldr::Export.from_i18n(locale)}.xml")].sort & Cldr::Export::Data.paths_by_root["ldml"]
          else
            Cldr::Export::Data.paths_by_root["supplementalData"]
          end
        end

        private

        def merge_paths(paths_to_merge)
          return Cldr::Export::DataFile.new(Nokogiri::XML("")) if paths_to_merge.empty?

          first = Cldr::Export::DataFile.parse(File.read(paths_to_merge.first))
          rest = paths_to_merge[1..]
          rest.reduce(first) do |result, path|
            parsed = Cldr::Export::DataFile.parse(File.read(path))
            result.merge!(parsed)
          end
        end
      end
    end
  end
end
