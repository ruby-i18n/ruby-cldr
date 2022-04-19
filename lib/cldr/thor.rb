# frozen_string_literal: true

require "thor"
require "cldr"
require "cldr/download"

module Cldr
  class Thor < ::Thor
    namespace "cldr"

    desc "download [--version=#{Cldr::Download::DEFAULT_VERSION}] [--target=#{Cldr::Download::DEFAULT_TARGET}] [--source=#{format(Cldr::Download::DEFAULT_SOURCE, version: Cldr::Download::DEFAULT_VERSION)}]", "Download and extract CLDR data"
    option :version, aliases: [:v], type: :numeric,
      default: Cldr::Download::DEFAULT_VERSION,
      banner: Cldr::Download::DEFAULT_VERSION,
      desc: "Release version of the CLDR data to use"
    option :target, aliases: [:t], type: :string,
      default: Cldr::Download::DEFAULT_TARGET,
      banner: Cldr::Download::DEFAULT_TARGET,
      desc: "Where on the filesystem to extract the downloaded data"
    option :source, aliases: [:s], type: :string,
      default: Cldr::Download::DEFAULT_SOURCE,
      banner: Cldr::Download::DEFAULT_SOURCE,
      desc: "Override the location of the CLDR zip to download. Overrides --version"
    def download
      Cldr::Download.download(options["source"], options["target"], options["version"])
    end

    DEFAULT_MINIMUM_DRAFT_STATUS = Cldr::DraftStatus::CONTRIBUTED

    desc "export [--locales=de fr-FR en-ZA] [--components=Numbers Plurals] [--target=#{Cldr::Export::DEFAULT_TARGET}] [--merge/--no-merge]",
      "Export CLDR data by locales and components to target dir"
    option :locales, aliases: [:l], type: :array, banner: "de fr-FR en-ZA", enum: Cldr::Export::Data.locales
    option :components, aliases: [:c], type: :array, banner: "Numbers Plurals", enum: Cldr::Export::Data.components
    option :target, aliases: [:t], type: :string, default: Cldr::Export::DEFAULT_TARGET, banner: Cldr::Export::DEFAULT_TARGET
    option :draft_status, aliases: [:d], type: :string,
      enum: Cldr::DraftStatus::FROM_STRING.keys,
      default: Cldr::DraftStatus.to_s(DEFAULT_MINIMUM_DRAFT_STATUS),
      banner: Cldr::DraftStatus.to_s(DEFAULT_MINIMUM_DRAFT_STATUS),
      desc: "The minimum draft status to include in the export"
    option :merge, aliases: [:m], type: :boolean, default: false
    def export
      $stdout.sync

      formatted_options = options.dup.symbolize_keys

      # We do this validation, since thor doesn't
      # https://github.com/rails/thor/issues/783
      if formatted_options.key?(:locales)
        formatted_options[:locales] = formatted_options[:locales].map(&:to_sym) if formatted_options.key?(:locales)
        unknown_locales = formatted_options[:locales] - Cldr::Export::Data.locales
        raise ArgumentError, "Unknown locales: #{unknown_locales.map { |l| "`#{l}`" }.join(", ")}" unless unknown_locales.empty?
      end
      if formatted_options.key?(:components)
        formatted_options[:components] = formatted_options[:components].map(&:to_sym) if formatted_options.key?(:components)
        unknown_components = formatted_options[:components] - Cldr::Export::Data.components
        raise ArgumentError, "Unknown components: #{unknown_components.join(", ")}" unless unknown_components.empty?
      end

      if formatted_options.key?(:draft_status)
        formatted_options[:minimum_draft_status] = Cldr::DraftStatus[formatted_options[:draft_status]]
        formatted_options.delete(:draft_status)
      end

      Cldr::Export.export(formatted_options) { putc(".") }
      puts
    end

    # TODO: flatten task, e.g. flatten all plural locale files into one big file
  end
end
