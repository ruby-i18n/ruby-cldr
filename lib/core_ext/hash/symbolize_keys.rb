# frozen_string_literal: true

class Hash
  def symbolize_keys
    each_with_object({}) { |(key, value), result|
      key = key.to_sym if key.respond_to?(:to_sym)
      result[key] = value
    }
  end
end
