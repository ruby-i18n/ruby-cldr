# frozen_string_literal: true

module Cldr
  module Ldml
    COMMENT_RE = /^\s*<!--@(.*)-->\s*$/
    ATTLIST_RE = /<!ATTLIST([^>]*)>/
    LDML_FILE = "vendor/cldr/common/dtd/ldml.dtd"

    class Attributes < Hash
      def initialize
        super
        attributes.group_by(&:element_name).transform_values { |values| values.to_h { |attribute| [attribute.attribute_name, attribute] } }.each do |key, value|
          self[key] = value
        end
      end

      private

      def attributes
        @attributes ||= begin
          acc = []
          results = []
          File.open(LDML_FILE) do |f|
            f.each_line do |line|
              if !acc.empty? && line =~ COMMENT_RE
                acc << Regexp.last_match(1).to_sym
              elsif !acc.empty?
                results << Cldr::Ldml::Attribute.parse(acc.first, acc[1..])
                acc = []
              end

              if line =~ ATTLIST_RE
                acc = [Regexp.last_match(1).strip]
              end
            end
          end
          results << Cldr::Ldml::Attribute.parse(acc.first, acc[1..]) unless acc.empty?

          results
        end
      end
    end
  end
end
