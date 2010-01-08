# encoding: utf-8

class Cldr
  module Format
    autoload :Base,     'cldr/format/base'
    autoload :Fraction, 'cldr/format/fraction'
    autoload :Integer,  'cldr/format/integer'
    autoload :Number,   'cldr/format/number'
    autoload :Numeric,  'cldr/format/numeric'

    def format_number(number, options = {})
      options = options.dup
      symbols = options.select { |key, value| [:decimal, :group].include?(key) }
      format  = options.delete(:format)
      Number.new(format, symbols).apply(number, options)
    end

    def format_currency(number, options = {})
      format_number(number, options).gsub('¤', options[:currency])
    end

    def format_percent(number, options = {})
      format_number(number, options).gsub('¤', options[:percent_sign])
    end
  end
end