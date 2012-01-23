require 'rubygems'
require 'rexml/document'

module Cldr
  module Export
    module Data
      class Plurals
        class Rules < Array
          class << self
            def parse(xml)
              rules = new
              REXML::Document.new(xml).elements.each('//pluralRules') do |tag|
                rule = Rule.new(tag.attributes['locales'].split(/\s+/))
                tag.elements.each('pluralRule') { |tag| rule << [tag.attributes['count'], tag.text] }
                rules << rule
              end
              rules
            end
          end
      
          def locales
            @locales ||= map { |rule| rule.locales }.flatten.map(&:to_s).sort.map(&:to_sym)
          end
      
          def rule(locale)
            detect { |rule| rule.locales.include?(locale.to_sym) }
          end
      
          def to_ruby(options = {})
            namespaces = options[:namespaces] || [:i18n]
            code = locales.map do |locale|
              rule = self.rule(locale)
              ruby = "{ :plural => { :keys => #{rule.keys.inspect}, :rule => #{rule.to_ruby} } }"
              ruby = namespaces.reverse.inject(ruby) { |ruby, namespace| "{ #{namespace.inspect} => #{ruby} }"}
              "#{locale.inspect} => #{ruby}"
            end.join(",\n")
            code = code.split("\n").map { |line| "  #{line}" }.join("\n")
            "{\n" + code + "\n}"
          end
        end
    
        class Rule < Array
          class << self
            def parse(code)
              case code
              when /and/
                code.split(/and/).inject(Proposition.new('&&')) { |rule, code| rule << parse(code) }
              when /or/
                code.split(/or/).inject(Proposition.new('||')) { |rule, code| rule << parse(code) }
              when /n( mod ([\d]+))? is (not )?([\d]+)/
                Expression.new(:is, $2, !!$3, $4)
              when /n( mod ([\d]+))?( not)? in ([\d]+\.\.[\d]+)/
                Expression.new(:in, $2, !!$3, eval($4).to_a.inspect)
              when /n within ([\d]+)\.\.([\d]+)/
                Expression.new(:within, nil, nil, [$1, $2])
              when /n/
                Expression.new
              else
                raise "can not parse #{code}"
              end
            end
          end

          attr_reader :locales

          def initialize(locales)
            @locales = locales.map { |locale| locale.gsub('_', '-').to_sym }
          end
      
          def keys
            inject([]) { |keys, (key, code)| keys << key.to_sym } << :other
          end
      
          def to_ruby
            @condition ||= 'lambda { |n| ' + reverse.inject(':other') do |result, (key, code)|
              code = self.class.parse(code).to_ruby
              "#{code} ? :#{key} : #{result}"
            end + ' }'
          end
        end

        class Proposition < Array
          def initialize(type = nil)
            @type = type
          end

          def to_ruby
            @ruby ||= map { |expr| expr.to_ruby }.join(" #{@type} ")
          end
        end

        class Expression
          attr_reader :operator, :operand, :mod, :negate

          def initialize(operator = nil, mod = nil, negate = nil, operand = nil)
            @operator, @mod, @negate, @operand = operator, mod, negate, operand
          end

          def to_ruby
            @ruby ||= begin
              op = 'n'
              op << " % #{@mod}" if mod
              case @operator
              when :is
                op + (@negate ? ' != ' : ' == ') + @operand
              when :in
                (@negate ? '!' : '') + "#{@operand}.include?(#{op})"
              when :within
                "#{op}.between?(#{@operand.first}, #{@operand.last})" 
              else
                op
              end
            end
          end
        end
      end
    end
  end
end