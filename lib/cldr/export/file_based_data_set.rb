# frozen_string_literal: true

require "nokogiri"

module Cldr
  module Export
    class FileBasedDataSet < DataSet
      attr_reader :directory

      def initialize(directory: nil, parent: nil)
        super(parent: parent)
        @directory = directory
      end

      private

      attr_reader :file_cache

      def compute(locale)
        merge_paths(paths(locale))
      end

      def locales_at_this_level
        Dir["#{directory}/main/*.xml"].map { |path| path =~ /([\w_-]+)\.xml/ && Regexp.last_match(1) }.map { |l| Cldr::Export.to_i18n(l) }
      end

      def paths_by_root
        @paths_by_root ||= Dir[File.join(directory, "**", "*.xml")].sort.group_by { |path| Nokogiri::XML(File.read(path)).root.name }
      end

      def paths(locale)
        if locale
          Dir[File.join(directory, "*", "#{Cldr::Export.from_i18n(locale)}.xml")].sort & paths_by_root["ldml"]
        else
          paths_by_root["supplementalData"]
        end
      end

      def merge_paths(paths_to_merge)
        return Cldr::Export::DataFile.new(Nokogiri::XML("")) if paths_to_merge.empty?

        first = Cldr::Export::DataFile.parse(File.read(paths_to_merge.first))
        rest = paths_to_merge[1..]
        rest.reduce(first) do |result, path|
          parsed = Cldr::Export::DataFile.parse(File.read(path))
          result.merge!(parsed)
        end
      end
    end
  end
end
