# http://unicode.org/draft/reports/tr35/tr35.html#Language_Plural_Rules
#
# condition       = and_condition ('or' and_condition)*
# and_condition   = relation ('and' relation)*
# relation        = is_relation | in_relation | within_relation | 'n' <EOL>
# is_relation     = expr 'is' ('not')? value
# in_relation     = expr ('not')? 'in' range
# within_relation = expr ('not')? 'within' range
# expr            = 'n' ('mod' value)?
# value           = digit+
# digit           = 0|1|2|3|4|5|6|7|8|9
# range           = value'..'value

class Cldr
  module Export
    module Data
      class Plurals
        module Grammar
          include Treetop::Runtime

          def root
            @root || :or_condition
          end

          module OrCondition0
            def and_condition
              elements[1]
            end
          end

          module OrCondition1
            def and_condition
              elements[0]
            end

          end

          def _nt_or_condition
            start_index = index
            if node_cache[:or_condition].has_key?(index)
              cached = node_cache[:or_condition][index]
              @index = cached.interval.end if cached
              return cached
            end

            i0, s0 = index, []
            r1 = _nt_and_condition
            s0 << r1
            if r1
              i3, s3 = index, []
              if input.index(" or ", index) == index
                r4 = instantiate_node(SyntaxNode,input, index...(index + 4))
                @index += 4
              else
                terminal_parse_failure(" or ")
                r4 = nil
              end
              s3 << r4
              if r4
                r5 = _nt_and_condition
                s3 << r5
              end
              if s3.last
                r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
                r3.extend(OrCondition0)
              else
                self.index = i3
                r3 = nil
              end
              if r3
                r2 = r3
              else
                r2 = instantiate_node(SyntaxNode,input, index...index)
              end
              s0 << r2
            end
            if s0.last
              r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
              r0.extend(OrCondition1)
            else
              self.index = i0
              r0 = nil
            end

            node_cache[:or_condition][start_index] = r0

            return r0
          end

          module AndCondition0
            def relation
              elements[1]
            end
          end

          module AndCondition1
            def relation
              elements[0]
            end

          end

          def _nt_and_condition
            start_index = index
            if node_cache[:and_condition].has_key?(index)
              cached = node_cache[:and_condition][index]
              @index = cached.interval.end if cached
              return cached
            end

            i0, s0 = index, []
            r1 = _nt_relation
            s0 << r1
            if r1
              i3, s3 = index, []
              if input.index(" and ", index) == index
                r4 = instantiate_node(SyntaxNode,input, index...(index + 5))
                @index += 5
              else
                terminal_parse_failure(" and ")
                r4 = nil
              end
              s3 << r4
              if r4
                r5 = _nt_relation
                s3 << r5
              end
              if s3.last
                r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
                r3.extend(AndCondition0)
              else
                self.index = i3
                r3 = nil
              end
              if r3
                r2 = r3
              else
                r2 = instantiate_node(SyntaxNode,input, index...index)
              end
              s0 << r2
            end
            if s0.last
              r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
              r0.extend(AndCondition1)
            else
              self.index = i0
              r0 = nil
            end

            node_cache[:and_condition][start_index] = r0

            return r0
          end

          def _nt_relation
            start_index = index
            if node_cache[:relation].has_key?(index)
              cached = node_cache[:relation][index]
              @index = cached.interval.end if cached
              return cached
            end

            i0 = index
            r1 = _nt_is_relation
            if r1
              r0 = r1
            else
              r2 = _nt_in_relation
              if r2
                r0 = r2
              else
                r3 = _nt_within_relation
                if r3
                  r0 = r3
                else
                  if input.index("n", index) == index
                    r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure("n")
                    r4 = nil
                  end
                  if r4
                    r0 = r4
                  else
                    self.index = i0
                    r0 = nil
                  end
                end
              end
            end

            node_cache[:relation][start_index] = r0

            return r0
          end

          module IsRelation0
            def expr
              elements[0]
            end

            def value
              elements[3]
            end
          end

          def _nt_is_relation
            start_index = index
            if node_cache[:is_relation].has_key?(index)
              cached = node_cache[:is_relation][index]
              @index = cached.interval.end if cached
              return cached
            end

            i0, s0 = index, []
            r1 = _nt_expr
            s0 << r1
            if r1
              if input.index(" is ", index) == index
                r2 = instantiate_node(SyntaxNode,input, index...(index + 4))
                @index += 4
              else
                terminal_parse_failure(" is ")
                r2 = nil
              end
              s0 << r2
              if r2
                if input.index("not ", index) == index
                  r4 = instantiate_node(SyntaxNode,input, index...(index + 4))
                  @index += 4
                else
                  terminal_parse_failure("not ")
                  r4 = nil
                end
                if r4
                  r3 = r4
                else
                  r3 = instantiate_node(SyntaxNode,input, index...index)
                end
                s0 << r3
                if r3
                  r5 = _nt_value
                  s0 << r5
                end
              end
            end
            if s0.last
              r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
              r0.extend(IsRelation0)
            else
              self.index = i0
              r0 = nil
            end

            node_cache[:is_relation][start_index] = r0

            return r0
          end

          module InRelation0
            def expr
              elements[0]
            end

            def range
              elements[3]
            end
          end

          def _nt_in_relation
            start_index = index
            if node_cache[:in_relation].has_key?(index)
              cached = node_cache[:in_relation][index]
              @index = cached.interval.end if cached
              return cached
            end

            i0, s0 = index, []
            r1 = _nt_expr
            s0 << r1
            if r1
              if input.index(" not", index) == index
                r3 = instantiate_node(SyntaxNode,input, index...(index + 4))
                @index += 4
              else
                terminal_parse_failure(" not")
                r3 = nil
              end
              if r3
                r2 = r3
              else
                r2 = instantiate_node(SyntaxNode,input, index...index)
              end
              s0 << r2
              if r2
                if input.index(" in ", index) == index
                  r4 = instantiate_node(SyntaxNode,input, index...(index + 4))
                  @index += 4
                else
                  terminal_parse_failure(" in ")
                  r4 = nil
                end
                s0 << r4
                if r4
                  r5 = _nt_range
                  s0 << r5
                end
              end
            end
            if s0.last
              r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
              r0.extend(InRelation0)
            else
              self.index = i0
              r0 = nil
            end

            node_cache[:in_relation][start_index] = r0

            return r0
          end

          module WithinRelation0
            def expr
              elements[0]
            end

            def range
              elements[3]
            end
          end

          def _nt_within_relation
            start_index = index
            if node_cache[:within_relation].has_key?(index)
              cached = node_cache[:within_relation][index]
              @index = cached.interval.end if cached
              return cached
            end

            i0, s0 = index, []
            r1 = _nt_expr
            s0 << r1
            if r1
              if input.index(" not", index) == index
                r3 = instantiate_node(SyntaxNode,input, index...(index + 4))
                @index += 4
              else
                terminal_parse_failure(" not")
                r3 = nil
              end
              if r3
                r2 = r3
              else
                r2 = instantiate_node(SyntaxNode,input, index...index)
              end
              s0 << r2
              if r2
                if input.index(" within ", index) == index
                  r4 = instantiate_node(SyntaxNode,input, index...(index + 8))
                  @index += 8
                else
                  terminal_parse_failure(" within ")
                  r4 = nil
                end
                s0 << r4
                if r4
                  r5 = _nt_range
                  s0 << r5
                end
              end
            end
            if s0.last
              r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
              r0.extend(WithinRelation0)
            else
              self.index = i0
              r0 = nil
            end

            node_cache[:within_relation][start_index] = r0

            return r0
          end

          module Expr0
            def value
              elements[1]
            end
          end

          module Expr1
          end

          def _nt_expr
            start_index = index
            if node_cache[:expr].has_key?(index)
              cached = node_cache[:expr][index]
              @index = cached.interval.end if cached
              return cached
            end

            i0, s0 = index, []
            if input.index("n", index) == index
              r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("n")
              r1 = nil
            end
            s0 << r1
            if r1
              i3, s3 = index, []
              if input.index(" mod ", index) == index
                r4 = instantiate_node(SyntaxNode,input, index...(index + 5))
                @index += 5
              else
                terminal_parse_failure(" mod ")
                r4 = nil
              end
              s3 << r4
              if r4
                r5 = _nt_value
                s3 << r5
              end
              if s3.last
                r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
                r3.extend(Expr0)
              else
                self.index = i3
                r3 = nil
              end
              if r3
                r2 = r3
              else
                r2 = instantiate_node(SyntaxNode,input, index...index)
              end
              s0 << r2
            end
            if s0.last
              r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
              r0.extend(Expr1)
            else
              self.index = i0
              r0 = nil
            end

            node_cache[:expr][start_index] = r0

            return r0
          end

          module Range0
            def value
              elements[0]
            end

            def value
              elements[2]
            end
          end

          def _nt_range
            start_index = index
            if node_cache[:range].has_key?(index)
              cached = node_cache[:range][index]
              @index = cached.interval.end if cached
              return cached
            end

            i0, s0 = index, []
            r1 = _nt_value
            s0 << r1
            if r1
              if input.index("..", index) == index
                r2 = instantiate_node(SyntaxNode,input, index...(index + 2))
                @index += 2
              else
                terminal_parse_failure("..")
                r2 = nil
              end
              s0 << r2
              if r2
                r3 = _nt_value
                s0 << r3
              end
            end
            if s0.last
              r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
              r0.extend(Range0)
            else
              self.index = i0
              r0 = nil
            end

            node_cache[:range][start_index] = r0

            return r0
          end

          def _nt_value
            start_index = index
            if node_cache[:value].has_key?(index)
              cached = node_cache[:value][index]
              @index = cached.interval.end if cached
              return cached
            end

            s0, i0 = [], index
            loop do
              if input.index(Regexp.new('[0-9]'), index) == index
                r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                r1 = nil
              end
              if r1
                s0 << r1
              else
                break
              end
            end
            r0 = instantiate_node(SyntaxNode,input, i0...index, s0)

            node_cache[:value][start_index] = r0

            return r0
          end
        end
      end

      class Parser < Treetop::Runtime::CompiledParser
        include Grammar
      end
    end
  end
end