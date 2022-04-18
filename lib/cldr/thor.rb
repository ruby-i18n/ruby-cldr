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

    desc "export [--locales=de fr en] [--components=numbers plurals] [--target=#{Cldr::Export::DEFAULT_TARGET}] [--merge/--no-merge]",
      "Export CLDR data by locales and components to target dir"
    option :locales, aliases: [:l], type: :array, banner: "de fr en"
    option :components, aliases: [:c], type: :array, banner: "numbers plurals"
    option :target, aliases: [:t], type: :string, default: Cldr::Export::DEFAULT_TARGET, banner: Cldr::Export::DEFAULT_TARGET
    option :merge, aliases: [:m], type: :boolean, default: false
    def export
      $stdout.sync
      Cldr::Export.export(options.dup.symbolize_keys) { putc(".") }
      puts
    end

    # TODO: flatten task, e.g. flatten all plural locale files into one big file
  end
end
