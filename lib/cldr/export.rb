# frozen_string_literal: true

require "i18n"
require "fileutils"
require "i18n/locale/tag"
require "core_ext/string/camelize"
require "core_ext/string/underscore"
require "core_ext/hash/deep_stringify"
require "core_ext/hash/deep_merge"
require "core_ext/hash/deep_prune"
require "core_ext/hash/deep_sort"

module Cldr
  module Export
    autoload :Code,              "cldr/export/code"
    autoload :Data,              "cldr/export/data"
    autoload :DataFile,          "cldr/export/data_file"
    autoload :DataSet,           "cldr/export/data_set"
    autoload :FileBasedDataSet,  "cldr/export/file_based_data_set"
    autoload :Ruby,              "cldr/export/ruby"
    autoload :Yaml,              "cldr/export/yaml"

    SHARED_COMPONENTS = [
      :Aliases, :CountryCodes, :CurrencyDigitsAndRounding, :LikelySubtags,
      :Metazones, :NumberingSystems, :ParentLocales, :RbnfRoot,
      :RegionCurrencies, :SegmentsRoot, :TerritoriesContainment,
      :Transforms, :Variables, :WindowsZones,
    ].freeze

    DEFAULT_TARGET = "./data"

    class << self
      def base_path
        @@base_path ||= File.expand_path(DEFAULT_TARGET)
      end

      def base_path=(base_path)
        @@base_path = File.expand_path(base_path)
      end

      def minimum_draft_status
        raise StandardError, "minimum_draft_status is not yet set." unless defined?(@@minimum_draft_status)

        @@minimum_draft_status
      end

      def minimum_draft_status=(draft_status)
        @@minimum_draft_status = draft_status
      end

      def export(options = {}, &block)
        locales        = options[:locales] || Data::RAW_DATA.locales
        components     = options[:components] || Data.components
        self.minimum_draft_status = options[:minimum_draft_status] if options[:minimum_draft_status]
        self.base_path = options[:target] if options[:target]

        shared_components, locale_components = components.partition do |component|
          shared_component?(component)
        end

        shared_components.each do |component|
          case component
          when :Transforms
            Dir.glob("#{Cldr::Export::Data::RAW_DATA.directory}/transforms/**.xml").each do |transform_file|
              data = Data::Transforms.new(transform_file)
              source = data[:transforms].first[:source]
              target = data[:transforms].first[:target]
              variant = data[:transforms].first[:variant]
              file_name = [source, target, variant].compact.join("-")
              output_path = File.join(base_path, "transforms", "#{file_name}.yml")
              write(output_path, data.to_yaml)
              yield component, nil, output_path if block_given?
            end
          else
            ex = exporter(component, options[:format])
            ex.export(nil, component, options, &block)
          end
        end

        locales.each do |locale|
          locale_components.each do |component|
            exporter(component, options[:format]).export(locale, component, options, &block)
          end
        end
      end

      def exporter(component, format)
        name = if format
          format
        else
          component == :Plurals ? "ruby" : "yaml"
        end
        const_get(name.to_s.camelize).new
      end

      def data(component, locale, options = {})
        case component
        when :Plurals
          plural_data(component, locale, options)
        else
          if shared_component?(component)
            shared_data(component, options)
          else
            locale_based_data(component, locale, options)
          end
        end
      end

      def locale_based_data(component, locale, options = {})
        data = locales(locale, component, options).inject({}) do |result, locale|
          data = Data.const_get(component.to_s).new(locale)
          if data
            data.is_a?(Hash) ? data.deep_merge(result) : data
          else
            result
          end
        end

        # data = resolve_links if options[:merge] TODO!!
        data
      end

      def plural_data(component, locale, options = {})
        result = locales(locale, component, options).lazy.map do |ancestor|
          Data::Plurals.rules.slice(ancestor)
        end.reject(&:empty?).first

        if result && result.keys != [locale]
          result[locale] = result.delete(result.keys.first)
        end

        result
      end

      def shared_data(component, options = {})
        case component
        when :Transforms
        # do nothing, this has to be handled separately
        else
          Data.const_get(component.to_s).new
        end
      end

      def to_i18n(locale)
        locale.to_s.gsub("_", "-").to_sym
      end

      def from_i18n(locale)
        locale.to_s.gsub("-", "_").to_sym
      end

      def locales(locale, component, options)
        locales = if options[:merge]
          Cldr.fallbacks[locale]
        else
          [locale, :root]
        end

        locales.pop unless should_merge_root?(locale, component, options)
        locales
      end

      def write(path, data)
        FileUtils.rm(path) if File.exist?(path)
        FileUtils.mkdir_p(File.dirname(path))
        File.write(path, data)
      end

      def path(locale, component, extension)
        path = [Export.base_path]
        unless shared_component?(component)
          path << "locales"
          path << locale.to_s
        end
        path << "#{component.to_s.underscore}.#{extension}"
        File.join(*path)
      end

      def shared_component?(component)
        SHARED_COMPONENTS.include?(component)
      end

      def should_merge_root?(locale, component, options)
        return false if [:Rbnf, :Fields].include?(component)
        return true if options[:merge]

        locale == :en
      end
    end
  end
end
