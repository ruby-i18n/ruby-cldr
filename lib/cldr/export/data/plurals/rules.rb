# frozen_string_literal: false

require "rubygems"
require "nokogiri"

module Cldr
  module Export
    module Data
      class Plurals
        class Rules < Hash
          class << self
            def read(data_file)
              rules = new
              data_file.xpath("//pluralRules").each do |node|
                rule = Rule.new
                node.xpath("pluralRule").each { |child| rule << [child.attribute("count").value, child.text] }

                locales = node.attribute("locales").value.split(/\s+/).map { |locale| Cldr::Export.to_i18n(locale) }
                locales.each { |locale| rules[locale] = rule }
              end
              rules
            end
          end

          def locales
            keys.sort
          end

          def slice(*keys)
            rules = self.class.new
            super.slice(*keys).each { |locale, rule| rules[locale] = rule }
            rules
          end

          def to_ruby(options = {})
            namespaces = options[:namespaces] || [:i18n]
            code = map do |locale, rule|
              ruby = "{ :plural => { :keys => #{rule.keys.inspect}, :rule => #{rule.to_ruby} } }"
              ruby = namespaces.reverse.inject(ruby) { |ruby, namespace| "{ #{namespace.inspect} => #{ruby} }" }
              "#{locale.inspect} => #{ruby}"
            end.join(",\n")
            code = code.split("\n").map(&:to_s).join("\n")
            "{ #{code} }"
          end
        end

        class Rule < Array
          class << self
            def parse_list(str)
              values = []
              ranges = []
              str.split(",").each do |value|
                parts = value.split("..")
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

              code = code.split("@").first.to_s
              operand = /(n|i|v|w|f|t|c|e)/i # Ordered as they appear in the spec.
              expr = /#{operand}(?:\s+(?:mod|%)\s+([\d]+))?/i
              range = /(?:\d+\.\.\d+|\d+)/i
              range_list = /(#{range}(?:\s*,\s*#{range})*)/i
              case code
              when /or/i
                code.split(/or/i).inject(Proposition.new("||")) { |rule, code| rule << parse(code) }
              when /and/i
                code.split(/and/i).inject(Proposition.new("&&")) { |rule, code| rule << parse(code) }
              when /^\s*#{expr}\s+(?:is(\s+not)?|(not\s+)?in|(!)?=)\s+#{range_list}\s*$/i
                list = parse_list(Regexp.last_match(6))
                Expression.new(list.first.count == 1 && list.last.count == 0 ? :is : :in, Regexp.last_match(2), !(Regexp.last_match(3).nil? && Regexp.last_match(4).nil? && Regexp.last_match(5).nil?), list.first.count == 1 && list.last.count == 0 ? list.first.first : list, Regexp.last_match(1))
              when /^\s*#{expr}\s+(not\s+)?within\s+#{range_list}\s*$/i
                Expression.new(:within, Regexp.last_match(2), !Regexp.last_match(3).nil?, parse_list(Regexp.last_match(4)).last.first, Regexp.last_match(1))
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

          def keys
            inject([]) { |keys, (key, _code)| keys << key.to_sym }
          end

          def to_ruby
            @condition ||= 'lambda { |n| n = n.respond_to?(:abs) ? n.abs : ((m = n.to_s)[0] == "-" ? m[1,m.length] : m); ' + reverse.inject(":other") do |result, (key, code)|
              code = self.class.parse(code).to_ruby
              if code
                "#{code} ? :#{key} : #{result}"
              else
                ":" << key.to_s
              end
            end + " }"
          end
        end

        class Proposition < Array
          def initialize(type = nil)
            super()

            @type = type
          end

          def to_ruby
            @ruby ||= "(" << map(&:to_ruby).join(" #{@type} ") << ")"
          end
        end

        class Expression
          attr_reader :operator, :operand, :mod, :negate, :type

          def initialize(operator = nil, mod = nil, negate = nil, operand = nil, type = nil)
            @operator = operator
            @mod = mod
            @negate = negate
            @operand = operand
            @type = type
          end

          # Symbol  Value
          # n       the absolute value of N.*
          # i       the integer digits of N.*
          # v       the number of visible fraction digits in N, _with_ trailing zeros.*
          # w       the number of visible fraction digits in N, _without_ trailing zeros.*
          # f       the visible fraction digits in N, _with_ trailing zeros, expressed as an integer.*
          # t       the visible fraction digits in N, _without_ trailing zeros, expressed as an integer.*
          # c       compact decimal exponent value: exponent of the power of 10 used in compact decimal formatting.
          # e       a deprecated synonym for ‘c’. Note: it may be redefined in the future.
          #
          # * If there is a compact decimal exponent value (‘c’), then the n, i, f, t, v, and w values are computed
          # after shifting the decimal point in the original by the ‘c’ value. So for 1.2c3, the n, i, f, t, v,
          # and w values are the same as those of 1200: i=1200 and f=0. Similarly, 1.2005c3 has i=1200 and
          # f=5 (corresponding to 1200.5).
          #
          # http://www.unicode.org/reports/tr35/tr35-numbers.html#Language_Plural_Rules
          def to_ruby
            @ruby ||= begin
              return nil unless @operator

              enclose = false
              fraction = false
              case @type
              when "i"
                op = "n.to_i"
              when "f"
                op = '(f = n.to_s.split(".")[1]) ? f.to_i : 0'
                enclose = true
              when "t"
                op = '(t = n.to_s.split(".")[1]) ? t.gsub(/0+$/, "").to_i : 0'
                enclose = true
              when "v"
                op = '(v = n.to_s.split(".")[1]) ? v.length : 0'
                enclose = true
              when "w"
                op = '(w = n.to_s.split(".")[1]) ? w.gsub(/0+$/, "").length : 0'
                enclose = true
              when "c", "e"
                # We don't support numbers in the "compact decimal" format.
                # Since `c`/`e` are always 0 for non-"compact decimal" format
                # numbers, we just hardcode it to 0 for now.
                # TODO: https://github.com/ruby-i18n/ruby-cldr/issues/131
                op = "#{@type} = 0"
                enclose = true
              when "n"
                fraction = true
                op = "n.to_f"
              else
                raise StandardError, "Unknown plural operand `#{@type}`"
              end
              if @mod
                op = "(" << op << ")" if enclose
                op << " % " << @mod.to_s
                enclose = false
              end
              case @operator
              when :is
                op = "(" << op << ")" if enclose
                op << (@negate ? " != " : " == ") << @operand.to_s
              when :in
                values = @operand.first
                ranges = @operand.last
                prepend = (@negate ? "!" : "")
                str = ""
                bop = op
                bop = "(" << bop << ")" if enclose || @mod
                if values.count == 1
                  str = bop + (@negate ? " != " : " == ") << values.first.to_s
                elsif values.count > 1
                  str = prepend + "#{values.inspect}.include?(#{op})"
                end
                enclose = ranges.count > 1 || (values.count > 0 && ranges.count > 0)
                if ranges.count > 0
                  str << " || " if values.count > 0
                  str << "((#{bop} % 1).zero? && " if fraction
                  str << "(" if ranges.count > 1
                  str << prepend + "(#{ranges.shift.inspect}).include?(#{op})"
                  ranges.each do |range|
                    str << " || " << prepend + "(#{range.inspect}).include?(#{op})"
                  end
                  str << ")" if ranges.count > 0
                  str << ")" if fraction
                end
                str = "(" << str << ")" if enclose
                str
              when :within
                op = "(" << op << ")" if enclose || @mod
                (@negate ? "!" : "") + "#{op}.between?(#{@operand.first}, #{@operand.last})"
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
