require 'i18n'
require 'i18n/locale/fallbacks'
require 'core_ext/string/camelize'
require 'core_ext/string/underscore'
require 'core_ext/hash/deep_stringify_keys'
require 'core_ext/hash/deep_merge'

module Cldr
  module Export
    autoload :Code, 'cldr/export/code'
    autoload :Data, 'cldr/export/data'
    autoload :Ruby, 'cldr/export/ruby'
    autoload :Yaml, 'cldr/export/yaml'

    SHARED_COMPONENTS = %w[
      CurrencyDigitsAndRounding
      Metazones
      NumberingSystems
      RbnfRoot
      SegmentsRoot
      TerritoriesContainment
      WindowsZones
      Transforms
      LikelySubtags
      Variables
      Aliases
      RegionCurrencies
    ]

    class << self
      def base_path
        @@base_path ||= File.expand_path('./data')
      end

      def base_path=(base_path)
        @@base_path = base_path
      end

      def export(options = {}, &block)
        locales        = options[:locales]    || Data.locales
        components     = (options[:components] || Data.components).map { |c| c.to_s.camelize }
        self.base_path = options[:target] if options[:target]

        shared_components, locale_components = components.partition do |component|
          is_shared_component?(component)
        end

        shared_components.each do |component|
          case component
            when "Transforms"
              yaml_exporter = Cldr::Export::Yaml.new
              Dir.glob("#{Cldr::Export::Data.dir}/transforms/**.xml").each do |transform_file|
                data = Data::Transforms.new(transform_file)
                source = data[:transforms].first[:source]
                target = data[:transforms].first[:target]
                output_path = File.join(base_path, "transforms", "#{source}-#{target}.yml")
                write(output_path, yaml_exporter.yaml(data))
                yield component, nil, output_path if block_given?
              end
            else
              ex = exporter(component, options[:format])
              ex.export('', component, options, &block)
          end
        end

        locales.each do |locale|
          locale_components.each do |component|
            exporter(component, options[:format]).export(locale, component, options, &block)
          end
        end
      end

      def exporter(component, format)
        name = format ? format : component.to_s == 'Plurals' ? 'ruby' : 'yaml'
        const_get(name.to_s.camelize).new
      end

      def data(component, locale, options = {})
        case component.to_s
          when 'Plurals'
            plural_data(component, locale, options)
          else
            if is_shared_component?(component)
              shared_data(component, options)
            else
              locale_based_data(component, locale, options)
            end
        end
      end

      def locale_based_data(component, locale, options = {})
        data = locales(locale, component, options).inject({}) do |result, locale|
          data = Data.const_get(component.to_s.camelize).new(locale)
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
        data = locale_based_data(component, locale, options)
        "{ :'#{locale}' => { :i18n => { :plural => { :keys => #{data[:keys].inspect}, :rule => #{data[:rule]} } } } }"
      end

      def shared_data(component, options = {})
        case component.to_s
          when 'Transforms'
            # do nothing, this has to be handled separately
          else
            Data.const_get(component.to_s.camelize).new
        end
      end

      def locales(locale, component, options)
        locale = locale.to_s.gsub('_', '-').to_sym

        locales = if options[:merge]
          # passing locale itself into constructor as a default fallback to avoid falling back to :en locale
          I18n::Locale::Fallbacks.new([locale])[locale]
        else
          [locale]
        end

        locales << :root if component_should_merge_root?(component)
        locales
      end

      def write(path, data)
        FileUtils.rm(path) if File.exists?(path)
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, 'w+') { |f| f.write(data) }
      end

      def path(locale, component, extension)
        path = [Export.base_path]
        path << locale.to_s.gsub('_', '-') unless is_shared_component?(component)
        path << "#{component.to_s.underscore}.#{extension}"
        File.join(*path)
      end

      def is_shared_component?(component)
        SHARED_COMPONENTS.include?(component)
      end

      def component_should_merge_root?(component)
        component != "Rbnf"
      end
    end
  end
end
