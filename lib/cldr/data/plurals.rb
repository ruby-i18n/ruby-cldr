require 'fileutils'

class Cldr
  module Data
    class Plurals < String
      autoload :Grammar,     'cldr/data/plurals/grammar'
      autoload :Parser,      'cldr/data/plurals/grammar'
      autoload :Rules,       'cldr/data/plurals/rules'
      autoload :Rule,        'cldr/data/plurals/rules'
      autoload :Proposition, 'cldr/data/plurals/rules'
      autoload :Expression,  'cldr/data/plurals/rules'

      class << self
        def rules
          @@rules ||= Rules.parse(source)
        end

        def source
          File.read("#{Cldr::Data.dir}/supplemental/plurals.xml")
        end
      end
    
      attr_reader :locale

      def initialize(locale)
        @locale = locale
        super(rule ? ruby : "")
      end
    
      def ruby
        "{ :#{locale} => { :i18n => {:plural => { :keys => #{rule.keys.inspect}, :rule => #{rule.to_ruby} } } } }"
      end
    
      def rule
        @rule = Plurals.rules.rule(locale)
      end
    end
  end
end