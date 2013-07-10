require 'i18n'
require 'i18n/locale/fallbacks'
require 'core_ext/string/camelize'
require 'core_ext/string/underscore'
require 'core_ext/hash/deep_stringify_keys'

module Cldr
  module Export
    autoload :Code, 'cldr/export/code'
    autoload :Data, 'cldr/export/data'
    autoload :Ruby, 'cldr/export/ruby'
    autoload :Yaml, 'cldr/export/yaml'

    class << self
      def base_path
        @@base_path ||= File.expand_path('./data')
      end

      def base_path=(base_path)
        @@base_path = base_path
      end

      def export(options = {}, &block)
        locales        = options[:locales]    || Data.locales
        components     = (options[:components] || Data.components).map{|c| c.to_s.camelize}
        self.base_path = options[:target] if options[:target]

        if components.include?('CurrencyDigitsAndRounding')
          components.delete('CurrencyDigitsAndRounding')
          exporter('CurrencyDigitsAndRounding', options[:format]).export('', 'CurrencyDigitsAndRounding', options, &block)
        end

        locales.each do |locale|
          components.each do |component|
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
          when 'CurrencyDigitsAndRounding'
            currency_rounding_data(component, locale, options)
          when 'Plurals'
            plural_data(component, locale, options)
          else
            default_data(component, locale, options)
        end
      end

      def default_data(component, locale, options = {})
        data = locales(locale, options).inject({}) do |result, locale|
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
        data = default_data(component, locale, options)
        "{ :'#{locale}' => { :i18n => { :plural => { :keys => #{data[:keys].inspect}, :rule => #{data[:rule]} } } } }"
      end

      def currency_rounding_data(component, locale, options = {})
        Data.const_get(component.to_s.camelize).new
      end

      def locales(locale, options)
        locale = locale.to_s.gsub('_', '-')
        locales = options[:merge] ? I18n::Locale::Fallbacks.new[locale.to_sym] : [locale.to_sym]
        locales << :root
        locales
      end

      def write(path, data)
        FileUtils.rm(path) if File.exists?(path)
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, 'w+') { |f| f.write(data) }
      end

      def path(locale, component, extension)
        "#{Export.base_path}/#{locale.to_s.gsub('_', '-')}/#{component.to_s.underscore}.#{extension}"
      end
    end
  end
end