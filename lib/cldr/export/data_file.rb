# frozen_string_literal: true

require "nokogiri"

module Cldr
  module Export
    class DataFile
      class << self
        def parse(string, minimum_draft_status: nil)
          doc = Nokogiri::XML(string) do |config|
            config.strict.noblanks
          end
          DataFile.new(doc, minimum_draft_status: minimum_draft_status)
        end

        def filter_by_draft(doc, minimum_draft_status)
          doc.traverse do |child|
            next unless child.text?

            draft_status = child.parent.attribute("draft").nil? ? Cldr::DraftStatus::APPROVED : Cldr::DraftStatus.fetch(child.parent.attribute("draft"))
            if draft_status < minimum_draft_status
              ancestors = child.ancestors
              child.remove
              # Remove the ancestors that are now empty
              ancestors.each do |ancestor|
                ancestor.remove if ancestor.children.empty?
              end
            end
          end
          doc
        end
      end

      attr_reader :doc, :minimum_draft_status

      def initialize(doc, minimum_draft_status: nil)
        @minimum_draft_status = minimum_draft_status || Cldr::Export.minimum_draft_status
        @doc = Cldr::Export::DataFile.filter_by_draft(doc, @minimum_draft_status)
      end

      def traverse(&block)
        @doc.traverse(&block)
      end

      def xpath(path)
        @doc.xpath(path)
      end

      def /(*args)
        @doc./(*args)
      end

      def locale
        language = @doc.xpath("//ldml/identity/language").first&.attribute("type")&.value
        territory = @doc.xpath("//ldml/identity/territory").first&.attribute("type")&.value
        elements = [language, territory].compact
        elements.empty? ? nil : elements.join("-").to_sym
      end

      def merge(other)
        # Some parts (`ldml`, `ldmlBCP47` amd `supplementalData`) of CLDR data require that you merge all the
        # files with the same root element before doing lookups.
        # Ref: https://www.unicode.org/reports/tr35/tr35.html#XML_Format
        #
        # Note that it technically is no longer compliant with the CLDR `ldml.dtd`, since:
        # * it has repeated elements
        # * the <identity> elements no longer refer to the filename
        #
        # However, this is not an issue, since #xpath will find all of the matches from each of the repeated elements,
        # and the <identity> elements are not important to us / make no sense when combined together.
        raise StandardError, "Cannot merge data file with more permissive draft status" if other.minimum_draft_status < minimum_draft_status
        raise StandardError, "Cannot merge data file from different locales" if other.locale != locale

        result = @doc.dup
        other.doc.root.children.each do |child|
          result.root.add_child(child.dup)
        end

        Cldr::Export::DataFile.new(result, minimum_draft_status: minimum_draft_status)
      end
    end
  end
end
