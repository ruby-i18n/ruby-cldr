require 'thor'
require 'cldr'

module Cldr
  class Thor < ::Thor
    namespace 'cldr'

    desc "download [--source=http://unicode.org/Public/cldr/1.7.2/core.zip] [--target=./vendor]",
         "Download and extract CLDR data from source to target dir"
    method_options %w(source -s) => :string,
                   %w(target -t) => :string

    def download
      require 'cldr/download'
      Cldr.download(options['source'], options['target'])
    end

    desc "export [--locales=de fr en] [--components=numbers plurals] [--target=./data] [--merge]",
         "Export CLDR data by locales and components to target dir"
    method_options %w(locales -l)    => :array,
                   %w(components -l) => :array,
                   %w(target  -t)    => :string,
                   %w(merge   -m)    => :boolean

    def export
      $stdout.sync
      Cldr::Export.export(options.dup.symbolize_keys) { putc '.' }
      puts
    end
  
    # TODO flatten task, e.g. flatten all plural locale files into one big file
  end
end