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
            !!node.attribute("count")
          end

          def draft?(node)
            draft = node.attribute("draft")
            draft && draft.value == "unconfirmed"
          end

          def alt?(node)
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
            path =~ /^\/?\/ldml/ ? path : "//ldml/#{path}"
          end

          def doc
            @@doc_cache[paths.hash] ||= merge_paths(paths)
          end

          def paths
            @paths ||= begin
              if locale
                Dir[File.join(Cldr::Export::Data.dir, "*", "#{Cldr::Export.from_i18n(locale)}.xml")].sort & Cldr::Export::Data.paths_by_root["ldml"]
              else
                Cldr::Export::Data.paths_by_root["supplementalData"]
              end
            end
          end

          private

          def merge_paths(paths_to_merge)
            # Some parts (`ldml`, `ldmlBCP47` amd `supplementalData`) of CLDR data require that you merge all the
            # files with the same root element before doing lookups.
            # Ref: https://www.unicode.org/reports/tr35/tr35.html#XML_Format
            #
            # The return of this method is a merged XML Nokogiri document.
            # Note that it technically is no longer compliant with the CLDR `ldml.dtd`, since:
            # * it has repeated elements
            # * the <identity> elements no longer refer to the filename
            #
            # However, this is not an issue, since #select will find all of the matches from each of the repeated elements,
            # and the <identity> elements are not important to us / make no sense when combined together.
            return Nokogiri::XML("") if paths_to_merge.empty?

            rest = paths_to_merge[1..paths_to_merge.size - 1]
            rest.inject(Nokogiri::XML(File.read(paths_to_merge.first))) do |result, path|
              next_doc = Nokogiri::XML(File.read(path))

              next_doc.root.children.each do |child|
                result.root.add_child(child)
              end

              result
            end
          end
      end
    end
  end
end
