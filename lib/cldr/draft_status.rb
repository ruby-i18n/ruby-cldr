# frozen_string_literal: true

module Cldr
  module DraftStatus
    class Status
      include Comparable

      def initialize(name, value)
        @name = name
        @value = value
      end

      def <=>(other)
        @value <=> other.value
      end

      def to_s
        @name.to_s
      end

      protected

      attr_reader :value
    end

    ALL = [
      :unconfirmed,
      :provisional,
      :contributed,
      :approved,
    ].map.with_index do |name, index|
      const_set(name.upcase, Status.new(name, index))
    end.freeze

    ALL_BY_NAME = ALL.to_h { |status| [status.to_s, status] }.freeze
    private_constant :ALL_BY_NAME

    class << self
      def fetch(name)
        ALL_BY_NAME.fetch(name.to_s)
      end
    end
  end
end
