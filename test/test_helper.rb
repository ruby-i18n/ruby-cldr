# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib"))

require "test/unit"
require "cldr"
require "rubygems"

class Test::Unit::TestCase
  def self.test(name, &block)
    test_name = "test_#{name.gsub(/\s+/, "_")}".to_sym
    defined = begin
      instance_method(test_name)
    rescue
      false
    end
    raise "#{test_name} is already defined in #{self}" if defined
    if block_given?
      define_method(test_name, &block)
    else
      define_method(test_name) do
        flunk("No implementation provided for #{name}")
      end
    end
  end
end
