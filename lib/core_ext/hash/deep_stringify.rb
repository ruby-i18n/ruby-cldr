# frozen_string_literal: true

class Hash
  def deep_stringify(stringify_keys: true, stringify_values: true)
    each_with_object({}) do |(key, value), result|
      value = value.deep_stringify(stringify_keys: stringify_keys, stringify_values: stringify_values) if value.is_a?(Hash)
      key = key.to_s if stringify_keys && key.is_a?(Symbol)
      value = value.to_s if stringify_values && value.is_a?(Symbol)
      result[key] = value
    end
  end

  def deep_stringify_keys
    deep_stringify(stringify_keys: true, stringify_values: false)
  end

  def deep_stringify_values
    deep_stringify(stringify_keys: false, stringify_values: true)
  end
end
