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

            def parse_list(str)
              values = []
              ranges = []
              str.split(',').each do |value|
                parts = value.split('..')
                if parts.count == 1
                  values << value.to_i
                else
                  ranges << (parts.first.to_i..parts.last.to_i)
                end
              end
              [values, ranges]
            end

            def parse(code)
              code = scrub_code(code)

              code = code.split('@').first.to_s
              operand = /(c|e|n|i|f|t|v|w)/i
              expr = /#{operand}(?:\s+(?:mod|%)\s+([\d]+))?/i
              range = /(?:\d+\.\.\d+|\d+)/i
              range_list = /(#{range}(?:\s*,\s*#{range})*)/i
              case code
              when /or/i
                code.split(/or/i).inject(Proposition.new('||')) { |rule, code| rule << parse(code) }
              when /and/i
                code.split(/and/i).inject(Proposition.new('&&')) { |rule, code| rule << parse(code) }
              when /^\s*#{expr}\s+(?:is(\s+not)?|(not\s+)?in|(!)?=)\s+#{range_list}\s*$/i
                list = parse_list($6)
                Expression.new((list.first.count == 1 && list.last.count == 0) ? :is : :in, $2, !($3.nil? && $4.nil? && $5.nil?), (list.first.count == 1 && list.last.count == 0) ? list.first.first : list, $1)
              when /^\s*#{expr}\s+(not\s+)?within\s+#{range_list}\s*$/i
                Expression.new(:within, $2, !($3==nil), parse_list($4).last.first, $1)
              when /^\s*$/
                Expression.new
              else
                raise "can not parse '#{code}'"
              end
            end

            private

            def scrub_code(code)
              code
                .gsub(/(n)%(\d+)/, '\1 % \2') # n%1000 -> n % 1000
                .gsub(/(\d+)=(\d+)/, '\1 = \2') # 10=100-> 10 = 100
                .gsub(/(n)!=(\d+)/, '\1 != \2') # n!=100 -> n != 100
            end
          end

          attr_reader :locales

          def initialize(locales)
            @locales = locales.map { |locale| locale.gsub('_', '-').to_sym }
          end

          def keys
            inject([]) { |keys, (key, code)| keys << key.to_sym }
          end

          def to_ruby
            @condition ||= 'lambda { |n| n = n.respond_to?(:abs) ? n.abs : ((m = n.to_s)[0] == "-" ? m[1,m.length] : m); ' + reverse.inject(':other') do |result, (key, code)|
              code = self.class.parse(code).to_ruby
              if code
                "#{code} ? :#{key} : #{result}"
              else
                ':' << key.to_s
              end
            end + ' }'
          end
        end

        class Proposition < Array
          def initialize(type = nil)
            @type = type
          end

          def to_ruby
            @ruby ||= '(' << map { |expr| expr.to_ruby }.join(" #{@type} ") << ')'
          end
        end

        class Expression
          attr_reader :operator, :operand, :mod, :negate, :type

          def initialize(operator = nil, mod = nil, negate = nil, operand = nil, type = nil)
            @operator, @mod, @negate, @operand, @type = operator, mod, negate, operand, type
          end

          # Symbol  Value
          # n       absolute value of the source number (integer and decimals).
          # i       integer digits of n.
          # v       number of visible fraction digits in n, with trailing zeros.
          # w       number of visible fraction digits in n, without trailing zeros.
          # f       visible fractional digits in n, with trailing zeros.
          # t       visible fractional digits in n, without trailing zeros.
          # c       compact decimal exponent value: exponent of the power of 10 used in compact decimal formatting.
          # e       currently, synonym for ‘c’. however, may be redefined in the future.
          #
          # http://www.unicode.org/reports/tr35/tr35-numbers.html#Language_Plural_Rules
          def to_ruby
            @ruby ||= begin
              return nil unless @operator
              enclose = false
              fraction = false
              case @type
              when 'i'
                op = 'n.to_i'
              when 'f'
                op = '(f = n.to_s.split(".")[1]) ? f.to_i : 0'
                enclose = true
              when 't'
                op = '(t = n.to_s.split(".")[1]) ? t.gsub(/0+$/, "").to_i : 0'
                enclose = true
              when 'v'
                op = '(v = n.to_s.split(".")[1]) ? v.length : 0'
                enclose = true
              when 'w'
                op = '(w = n.to_s.split(".")[1]) ? w.gsub(/0+$/, "").length : 0'
                enclose = true
              when 'c', 'e'
                # We don't support numbers in the "compact decimal" format.
                # Since `c`/`e` are always 0 for non-"compact decimal" format
                # numbers, we just hardcode it to 0 for now.
                op = "#{@type} = 0"
                enclose = true
              when 'n'
                fraction = true
                op = 'n.to_f'
              else
                raise "unknown type '#{@type}'"
              end
              if @mod
                op = '(' << op << ')' if enclose
                op << ' % ' << @mod.to_s
                enclose = false
              end
              case @operator
              when :is
                op = '(' << op << ')' if enclose
                op << (@negate ? ' != ' : ' == ') << @operand.to_s
              when :in
                values = @operand.first
                ranges = @operand.last
                prepend = (@negate ? '!' : '')
                str = ''
                bop = op
                bop = '(' << bop << ')' if enclose || @mod
                if values.count == 1
                  str = bop + (@negate ? ' != ' : ' == ') << values.first.to_s
                elsif values.count > 1
                  str = prepend + "#{values.inspect}.include?(#{op})"
                end
                enclose = ranges.count > 1 || (values.count > 0 && ranges.count > 0)
                if ranges.count > 0
                  str << ' || ' if values.count > 0
                  str << "((#{bop} % 1).zero? && " if fraction
                  str << '(' if ranges.count > 1
                  str << prepend + "(#{ranges.shift.inspect}).include?(#{op})"
                  ranges.each do |range|
                    str << ' || ' << prepend + "(#{range.inspect}).include?(#{op})"
                  end
                  str << ')' if ranges.count > 0
                  str << ')' if fraction
                end
                str = '(' << str << ')' if enclose
                str
              when :within
                op = '(' << op << ')' if enclose || @mod
                (@negate ? '!' : '') + "#{op}.between?(#{@operand.first}, #{@operand.last})"
              else
                raise "unknown operator '#{@operator}'"
              end
            end
          end
        end
      end
    end
  end
end
