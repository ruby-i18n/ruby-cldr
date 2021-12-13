# frozen_string_literal: true

class Hash
  def deep_merge(other)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : (v2 || v1) }
    merge(other, &merger)
  end
end
 