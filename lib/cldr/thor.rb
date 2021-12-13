require "thor"
require "cldr"

module Cldr
  class Thor < ::Thor
    namespace "cldr"

    desc "download [--version=34] [--target=./vendor] [--source=http://unicode.org/Public/cldr/34/core.zip]",
        <<~DESCRIPTION
          Download and extract CLDR data:
            * Use the --version parameter to set the release version of the CLDR data to use
            * Use the --target parameter to specify where on the filesystem to extract the downloaded data
            * Use the --source parameter to override the location of the CLDR zip to download. Overrides --version
        DESCRIPTION
    method_options %w(source -s) => :string,
                   %w(target -t) => :string,
                   %w(version -v) => :string

    def download
      require "cldr/download"
      Cldr.download(options["source"], options["target"], options["version"])
    end

    desc "export [--locales=de fr en] [--components=numbers plurals] [--target=./data] [--merge]",
         "Export CLDR data by locales and components to target dir"
    method_options %w(locales -l)    => :array,
                   %w(components -l) => :array,
                   %w(target  -t)    => :string,
                   %w(merge   -m)    => :boolean

    def export
      $stdout.sync
      Cldr::Export.export(options.dup.symbolize_keys) { putc "." }
      puts
    end

    # TODO flatten task, e.g. flatten all plural locale files into one big file
  end
end
