# frozen_string_literal: true

class String
  def camelize
    gsub(/(^.|_[a-zA-Z])/) { |m| m.sub("_", "").capitalize }
  end
end unless String.new.respond_to?(:camelize)
