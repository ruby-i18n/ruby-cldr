# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__) + '/../test_helper'))

class TestYaml < Test::Unit::TestCase
  test 'Hash values are deep sorted' do
    data = Cldr::Export::Yaml.new.export('fr', 'currencies', :merge => true)
    assert_equal deep_flatten(data.deep_sort).to_a, deep_flatten(data).to_a
  end

  private

  def deep_flatten(hash, output = {}, parent_key = [])
    hash.keys.each do |key|
      current_key = parent_key + [key]

      if hash[key].is_a?(Hash)
        deep_flatten(hash[key], output, current_key)
      else
        output[current_key] = hash[key]
      end
    end

    output
  end
end
