# frozen_string_literal: true

module DeepPrune
  def deep_prune!(comparator = ->(v) { v.is_a?(Hash) && v.empty? })
    delete_if do |_, v|
      v.deep_prune!(comparator) if v.is_a?(Hash)
      comparator.call(v)
    end
  end
end

Hash.send(:include, DeepPrune)
