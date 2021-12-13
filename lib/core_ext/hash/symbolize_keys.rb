# frozen_string_literal: true

class Hash
  def symbolize_keys
    inject({}) { |result, (key, value)|
      key = key.to_sym if key.respond_to?(:to_sym)
      result[key] = value
      result
    }
  end
end
