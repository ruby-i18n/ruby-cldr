namespace :cldr do
  desc 'export cldr data'
  task :export do
    require 'cldr'
    $stdout.sync
    Cldr::Data.export { putc '.' }
    puts
  end
end