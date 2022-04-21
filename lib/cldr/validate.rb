# frozen_string_literal: true

require "parser/current"

module Cldr
  class Validate
    class << self
      def validate(target)
        errors = Dir.glob("#{target}/**/*.yml").reject {|path| path.match?(%r{/transforms/})}.flat_map do |path|
          validate_yaml_file(path)
        end
        errors += Dir.glob("#{target}/**/*.rb").flat_map do |path|
          validate_ruby_file(path)
        end
        errors.each do |error|
          puts(error.message)
        end
        exit(errors.empty? ? 0 : 1)
      end

      private

      def validate_yaml_file(path)
        errors = []
        contents = YAML.load_file(path, permitted_classes: [Cldr::Export::Data::Transforms, DateTime, Symbol, Time])
        flattened = contents # TODO: flatten contents
        flattened.each do |key, value|
          errors << StandardError.new("`#{key}` in `#{path}` is not a string") unless key.is_a?(String)
          errors << StandardError.new("Value for `#{key}` in `#{path}` is nil") if value.nil?
          errors << StandardError.new("Value for `#{key}` in `#{path}` is empty") if value.empty?
        end
        errors
      end

      def validate_ruby_file(path)
        errors = []
        begin
          Parser::CurrentRuby.parse(File.read(path))
        rescue Parser::SyntaxError
          errors << StandardError.new("`#{path}` fails to parse as Ruby code")
        end
        errors
      end
    end
  end
end
