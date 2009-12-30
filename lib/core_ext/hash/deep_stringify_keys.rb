class Hash
  def deep_stringify_keys
    inject({}) { |result, (key, value)|
      value = value.deep_stringify_keys if value.is_a?(Hash)
      key = key.to_s if key.is_a?(Symbol)
      result[key] = value
      result
    }
  end
end
 