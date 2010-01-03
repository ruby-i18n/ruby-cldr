require 'ya2yaml'

class Cldr
  module Export
    class Yaml < Ya2YAML
      def initialize
        super(:syck_compatible => true)
      end

      def export(locale, component)
        data = Export.data(component, locale)
        unless data.empty?
          data = { locale.gsub('_', '-') => data }.deep_stringify_keys
          path = Export.path(locale, component, 'yml')
          Export.write(path, yaml(data))
          yield(component, locale, path) if block_given?
        end
      end

    	def yaml(data)
    		emit(data, 1)[1..-1]
    	end

    	def emit(object, level)
    		result = object.is_a?(Symbol) ? object.to_s : super
    		result.gsub(/(\s{1})(no):/i) { %(#{$1}"#{$2}":) } # FIXME fucking spaghetti code
    	end

    	def is_one_plain_line?(str)
    		# removed REX_BOOL, REX_INT
    		str !~ /^([\-\?:,\[\]\{\}\#&\*!\|>'"%@`\s]|---|\.\.\.)/    &&
    		str !~ /[:\#\s\[\]\{\},]/                                  &&
    		str !~ /#{REX_ANY_LB}/                                     &&
    		str !~ /^(#{REX_FLOAT}|#{REX_MERGE}|#{REX_NULL}|#{REX_TIMESTAMP}|#{REX_VALUE})$/x
    	end
    end
  end
end
