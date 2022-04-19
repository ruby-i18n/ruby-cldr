# frozen_string_literal: true

module Cldr
  module DraftStatus
    UNCONFIRMED = 1
    PROVISIONAL = 2
    CONTRIBUTED = 3
    APPROVED = 4

    FROM_STRING = {
      "unconfirmed" => UNCONFIRMED,
      "provisional" => PROVISIONAL,
      "contributed" => CONTRIBUTED,
      "approved" => APPROVED,
    }.freeze

    def self.[](key)
      FROM_STRING[(key.to_s)]
    end

    def self.fetch(key)
      FROM_STRING.fetch(key.to_s)
    end

    def self.to_s(status)
      FROM_STRING.invert[status]
    end
  end
end
