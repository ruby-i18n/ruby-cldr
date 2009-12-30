module Cldr
  module Data
    class Languages < Base
      def data
        names = extract(
        	{ 'localeDisplayNames/languages/*' => 'languages' },
        	{ :key   => lambda { |node| [node.attribute('type').value.gsub('_', '-').to_sym, :name] } } 
        )
        codes = extract(
        	{ 'localeDisplayNames/languages/*' => 'languages' },
        	{ :key   => lambda { |node| [node.attribute('type').value.gsub('_', '-').to_sym, :code] },
        	  :value => lambda { |node|  node.attribute('type').value.gsub('_', '-').to_sym } } 
        )
        names.deep_merge(codes)
      end
    end
  end
end