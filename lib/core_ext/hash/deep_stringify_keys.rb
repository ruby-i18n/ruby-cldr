# frozen_string_literal: true

class Hash
  def deep_stringify_keys
    each_with_object({}) do |(key, value), result|
      value = value.deep_stringify_keys if value.is_a?(Hash)
      key = key.to_s if key.is_a?(Symbol)
      result[key] = value
    end
  end
end
