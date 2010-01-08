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
  end
end