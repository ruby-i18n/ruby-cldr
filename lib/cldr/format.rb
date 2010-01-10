# encoding: utf-8

class Cldr
  module Format
    autoload :Base,     'cldr/format/base'
    autoload :Currency, 'cldr/format/currency'
    autoload :Fraction, 'cldr/format/fraction'
    autoload :Integer,  'cldr/format/integer'
    autoload :Number,   'cldr/format/number'
    autoload :Numeric,  'cldr/format/numeric'
    autoload :Percent,  'cldr/format/percent'

    def format_integer(number, options = {})
      format_number(number, options.merge(:precision => 0))
    end
    alias format_int format_integer

    def format_currency(number, options = {})
      format_number(number, options).gsub('¤', options[:currency])
    end

    def format_percent(number, options = {})
      format_number(number, options).gsub('¤', options[:percent_sign])
    end

    def format_number(number, options = {})
      if options[:as]
        send(:"format_#{options.delete(:as)}", number, options)
      else
        options = options.dup
        symbols = options.select { |key, value| [:decimal, :group].include?(key) }
        format  = options.delete(:format)
        Number.new(format, symbols).apply(number, options)
      end
    end

    extend self
  end
end