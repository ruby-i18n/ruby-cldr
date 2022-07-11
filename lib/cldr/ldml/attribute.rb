# frozen_string_literal: true

module Cldr
  module Ldml
    class Attribute
      class << self
        def parse(attlist, comments)
          element_name, attribute_name, type, mode = attlist.strip.split(/\s+/).map(&:to_sym)
          status = comments.find { |comment| comment == :VALUE || comment == :METADATA } || :DISTINGUISHING
          deprecated = comments.any? { |comment| comment == :DEPRECATED }
          Attribute.new(element_name, attribute_name, type, mode, status, deprecated)
        end
      end

      attr_reader :element_name, :attribute_name, :type, :mode

      def initialize(element_name, attribute_name, type, mode, status, deprecated) # rubocop:disable Metrics/ParameterLists
        @element_name = element_name
        @attribute_name = attribute_name
        @type = type
        @mode = mode
        @status = status
        @deprecated = deprecated
      end

      def distinguishing?
        @status == :DISTINGUISHING
      end

      def deprecated?
        @deprecated
      end
    end
  end
end
