require 'rubygems'
require 'thor'
require 'core_ext/hash/symbolize_keys'

class Cldr < Thor
  autoload :Data,   'cldr/data'
  autoload :Export, 'cldr/export'
  autoload :Format, 'cldr/format'

  desc "export [--locales=de fr en] [--components=numbers plurals] [--target=./data]",
       "Export CLDR data by locales and components to target dir"
  method_options %w(locales -l components -c) => :array, %w(target -t) => :string

  def export
    $stdout.sync
    Cldr::Export.export(options.dup.symbolize_keys) { putc '.' }
    puts
  end
end