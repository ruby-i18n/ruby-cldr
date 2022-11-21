# frozen_string_literal: true

require "uri"
require "open-uri"
require "zip"

module Cldr
  module Download
    DEFAULT_SOURCE = "http://unicode.org/Public/cldr/%{version}/core.zip"
    DEFAULT_TARGET = "./vendor/cldr"
    DEFAULT_VERSION = 41

    class << self
      def download(source = DEFAULT_SOURCE, target = DEFAULT_TARGET, version = DEFAULT_VERSION, pre_release: false, &block)
        if pre_release
          download_prerelease(source, target, version, &block)
        else
          download_release(source, target, version, &block)
        end
      end

      private

      def download_release(source, target, version, &block)
        source = format(source, version: version)
        target ||= File.expand_path(DEFAULT_TARGET)

        URI.parse(source).open do |tempfile|
          FileUtils.mkdir_p(target)
          Zip.on_exists_proc = true
          Zip::File.open(tempfile.path) do |file|
            file.each do |entry|
              path = File.join(target, entry.name)
              FileUtils.mkdir_p(File.dirname(path))
              file.extract(entry, path)
              yield path
            end
          end
        end
      end

      def download_prerelease(source, target, version, &block)
        source = format(source, version: version)
        target ||= File.expand_path(DEFAULT_TARGET)

        URI.parse(source).open do |tempfile|
          FileUtils.mkdir_p(target)
          Zip.on_exists_proc = true
          Zip::File.open(tempfile.path) do |file|
            root_dir = file.first.name
            production_dir = root_dir + "production"
            file.each do |entry|
              next unless entry.name.start_with?(production_dir)

              path = target + "/" + entry.name.gsub(production_dir, "")
              FileUtils.mkdir_p(File.dirname(path))
              file.extract(entry, path)
            end
          end
        end
      end
    end
  end
end
