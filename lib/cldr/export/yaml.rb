require 'ya2yaml'

module Cldr
  module Export
    class Yaml < Ya2YAML
      def initialize
        super(:syck_compatible => true)
      end

      def export(locale, component, options = {})
        data = Export.data(component, locale, options)
        unless data.empty?
          data = data.deep_stringify_keys if data.respond_to?(:deep_stringify_keys)
          data = { locale.to_s.gsub('_', '-') => data } if locale != ""
          path = Export.path(locale, component, 'yml')
          Export.write(path, yaml(data))
          yield(component, locale, path) if block_given?
          data
        end
      end

      def yaml(data)
        emit(data, 1)[1..-1]
      end

      def emit(object, level = 1)
        result = object.is_a?(Symbol) ? object.inspect : super
        result.gsub(/(\s{1})(no):/i) { %(#{$1}"#{$2}":) } # FIXME fucking spaghetti code
      end

      def is_one_plain_line?(str)
        # removed REX_BOOL, REX_INT
        str !~ /^([\-\?:,\[\]\{\}\#&\*!\|>'"%@`\s]|---|\.\.\.)/ &&
          str !~ /[:\#\s\[\]\{\},]/ &&
          str !~ /#{REX_ANY_LB}/ &&
          str !~ /^0[0-7]+$/ &&
          str !~ /^(#{REX_FLOAT}|#{REX_MERGE}|#{REX_NULL}|#{REX_TIMESTAMP}|#{REX_VALUE})$/x
      end
    end
  end
end
