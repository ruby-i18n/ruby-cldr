module Cldr
  module Data
    class Territories < Base
      def data
        names = extract(
          { 'localeDisplayNames/territories/*' => 'territories' },
          { :key   => lambda { |node| [node.attribute('type').value.gsub('_', '-').to_sym, :name] } } 
        )
        codes = extract(
          { 'localeDisplayNames/territories/*' => 'territories' },
          { :key   => lambda { |node| [node.attribute('type').value.gsub('_', '-').to_sym, :code] },
            :value => lambda { |node|  node.attribute('type').value.gsub('_', '-').to_sym } } 
        )
        names.deep_merge(codes)
      end
    end
  end
end