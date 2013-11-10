require File.join(File.expand_path(File.dirname(__FILE__)), '../../test_helper')

class TestCldrDataPluralParser < Test::Unit::TestCase
  def cldr_data
    File.read(File.dirname(__FILE__) + '/../../../vendor/cldr/common/supplemental/plurals.xml')
  end
  
  def cldr_rules
    Cldr::Export::Data::Plurals::Rules.parse(cldr_data)
  end
  
  def test_compiles_to_valid_ruby_code
    assert_nothing_raised { eval(cldr_rules.to_ruby) }
  end
  
  def test_evals_to_a_hash_containing_plural_rule_and_keys_per_locale
    data = eval(cldr_rules.to_ruby)
    assert Hash === data
    assert Proc === data[:de][:i18n][:plural][:rule]
    assert_equal [:one, :other], data[:de][:i18n][:plural][:keys]
  end
  
  def test_lookup_rule_by_locale
    assert_equal 'lambda { |n| (n.to_i.to_s.length == 1 && ((v = n.to_s.split(".")).count > 1 ? v.last.length : 0) == 0) ? :one : :other }', cldr_rules.rule(:de).to_ruby
  end

  def test_parses_empty
    assert Cldr::Export::Data::Plurals::Rule.parse('').is_a?(Cldr::Export::Data::Plurals::Expression)
    assert Cldr::Export::Data::Plurals::Rule.parse(' ').is_a?(Cldr::Export::Data::Plurals::Expression)
    assert Cldr::Export::Data::Plurals::Rule.parse(' @integer').is_a?(Cldr::Export::Data::Plurals::Expression)
    assert Cldr::Export::Data::Plurals::Rule.parse('@decimal').is_a?(Cldr::Export::Data::Plurals::Expression)
  end

  def test_parses_n_is_1
    rule = Cldr::Export::Data::Plurals::Rule.parse('n is 1')
    assert_equal [:is, 1], [rule.operator, rule.operand]
  end

  def test_parses_n_mod_1_is_1
    rule = Cldr::Export::Data::Plurals::Rule.parse('n mod 1 is 1')
    assert_equal [:is, 1, '1', 'n'], [rule.operator, rule.operand, rule.mod, rule.type]
  end

  def test_parses_n_is_not_1
    rule = Cldr::Export::Data::Plurals::Rule.parse('n is not 1')
    assert_equal [:is, 1, true, 'n'], [rule.operator, rule.operand, rule.negate, rule.type]
  end

  def test_parses_n_mod_1_is_not_1
    rule = Cldr::Export::Data::Plurals::Rule.parse('n mod 1 is not 1')
    assert_equal [:is, 1, true, '1', 'n'], [rule.operator, rule.operand, rule.negate, rule.mod, rule.type]
  end

  def test_parses_n_in_1_2
    rule = Cldr::Export::Data::Plurals::Rule.parse('n in 1..2')
    assert_equal [:in, [[],[1..2]], 'n'], [rule.operator, rule.operand, rule.type]
  end

  def test_parses_n_mod_1_in_1_2
    rule = Cldr::Export::Data::Plurals::Rule.parse('n mod 1 in 1..2')
    assert_equal [:in, [[],[1..2]], '1', 'n'], [rule.operator, rule.operand, rule.mod, rule.type]
  end

  def test_parses_n_not_in_1_2
    rule = Cldr::Export::Data::Plurals::Rule.parse('n not in 1..2')
    assert_equal [:in, [[],[1..2]], true, 'n'], [rule.operator, rule.operand, rule.negate, rule.type]
  end

  def test_parses_n_mod_1_not_in_1_2
    rule = Cldr::Export::Data::Plurals::Rule.parse('n mod 1 not in 1..2')
    assert_equal [:in, [[],[1..2]], true, '1', 'n'], [rule.operator, rule.operand, rule.negate, rule.mod, rule.type]
  end

  def test_parses_n_within_0_2
    expression = Cldr::Export::Data::Plurals::Rule.parse('n within 0..2')
    assert_equal [:within, 0..2, 'n'], [expression.operator, expression.operand, expression.type]
  end

  def test_parses_n_list_range
    expression = Cldr::Export::Data::Plurals::Rule.parse('n % 100 != 10..19,30,34,39,90..99')
    assert_equal [:in, [[30, 34, 39],[10..19, 90..99]], true, '100', 'n'], [expression.operator, expression.operand, expression.negate, expression.mod, expression.type]
  end

  def test_parses_or_condition
    rule = Cldr::Export::Data::Plurals::Rule.parse('n mod 1 is not 2 or n mod 2 in 3..4')
    assert_equal 2, rule.size
    assert_equal [:is, 2, true, '1', 'n'], [rule[0].operator, rule[0].operand, rule[0].negate, rule[0].mod, rule[0].type]
    assert_equal [:in, [[],[3..4]], false, '2', 'n'], [rule[1].operator, rule[1].operand, rule[1].negate, rule[1].mod, rule[1].type]
  end

  def test_parses_and_condition
    rule = Cldr::Export::Data::Plurals::Rule.parse('n mod 1 is not 2 and n mod 2 in 3..4')
    assert_equal 2, rule.size
    assert_equal [:is, 2, true, '1', 'n'], [rule[0].operator, rule[0].operand, rule[0].negate, rule[0].mod, rule[0].type]
    assert_equal [:in, [[],[3..4]], false, '2', 'n'], [rule[1].operator, rule[1].operand, rule[1].negate, rule[1].mod, rule[1].type]
  end

  def test_parses_and_priority
    rule = Cldr::Export::Data::Plurals::Rule.parse('i = 0 or v != 1 and f % 2 = 3..4')
    assert_equal 2, rule.size
    assert_equal 2, rule[1].size
    assert_equal [:is, 0, 'i'], [rule[0].operator, rule[0].operand, rule[0].type]
    assert_equal [:is, 1, true, 'v'], [rule[1][0].operator, rule[1][0].operand, rule[1][0].negate, rule[1][0].type]
    assert_equal [:in, [[],[3..4]], '2', 'f'], [rule[1][1].operator, rule[1][1].operand, rule[1][1].mod, rule[1][1].type]
  end

  def test_compiles_empty
    assert_equal nil, Cldr::Export::Data::Plurals::Rule.parse('').to_ruby
    assert_equal nil, Cldr::Export::Data::Plurals::Rule.parse(' ').to_ruby
    assert_equal nil, Cldr::Export::Data::Plurals::Rule.parse(' @integer').to_ruby
    assert_equal nil, Cldr::Export::Data::Plurals::Rule.parse('@decimal').to_ruby
  end

  def test_compiles_n_is_2
    assert_equal 'n.to_f == 2', Cldr::Export::Data::Plurals::Rule.parse('n is 2').to_ruby
  end

  def test_compiles_n_mod_1_is_2
    assert_equal 'n.to_f % 1 == 2', Cldr::Export::Data::Plurals::Rule.parse('n mod 1 is 2').to_ruby
  end

  def test_compiles_n_is_not_2
    assert_equal 'n.to_f != 2', Cldr::Export::Data::Plurals::Rule.parse('n is not 2').to_ruby
  end

  def test_compiles_n_mod_1_is_not_2
    assert_equal 'n.to_f % 1 != 2', Cldr::Export::Data::Plurals::Rule.parse('n mod 1 is not 2').to_ruby
  end

  def test_compiles_n_in_1_2
    assert_equal '((n.to_f % 1).zero? && (1..2).include?(n.to_f))', Cldr::Export::Data::Plurals::Rule.parse('n in 1..2').to_ruby
  end

  def test_compiles_n_mod_1_in_1_2
    assert_equal '(((n.to_f % 1) % 1).zero? && (1..2).include?(n.to_f % 1))', Cldr::Export::Data::Plurals::Rule.parse('n mod 1 in 1..2').to_ruby
  end

  def test_compiles_n_not_in_1_2
    assert_equal '((n.to_f % 1).zero? && !(1..2).include?(n.to_f))', Cldr::Export::Data::Plurals::Rule.parse('n not in 1..2').to_ruby
  end

  def test_compiles_n_mod_1_not_in_1_2
    assert_equal '(((n.to_f % 1) % 1).zero? && !(1..2).include?(n.to_f % 1))', Cldr::Export::Data::Plurals::Rule.parse('n mod 1 not in 1..2').to_ruby
  end

  def test_compiles_or_condition
    assert_equal '(n.to_f % 1 != 2 || (((n.to_f % 2) % 1).zero? && (3..4).include?(n.to_f % 2)))', Cldr::Export::Data::Plurals::Rule.parse('n mod 1 is not 2 or n mod 2 in 3..4').to_ruby
  end

  def test_compiles_and_condition
    assert_equal '(n.to_f % 1 != 2 && (((n.to_f % 2) % 1).zero? && (3..4).include?(n.to_f % 2)))', Cldr::Export::Data::Plurals::Rule.parse('n mod 1 is not 2 and n mod 2 in 3..4').to_ruby
  end

  def test_compiles_and_priority
    assert_equal '(n.to_i.to_s.length == 0 || (((v = n.to_s.split(".")).count > 1 ? v.last.length : 0) != 1 && (((((f = n.to_s.split(".")).count > 1 ? f.last.to_i : 0) % 2) % 1).zero? && (3..4).include?(((f = n.to_s.split(".")).count > 1 ? f.last.to_i : 0) % 2))))', Cldr::Export::Data::Plurals::Rule.parse('i = 0 or v != 1 and f mod 2 = 3..4').to_ruby
  end

  def test_compiles_n_mod_100_in_3_99
    assert_equal '(((n.to_f % 100) % 1).zero? && (3..6).include?(n.to_f % 100))', Cldr::Export::Data::Plurals::Rule.parse('n mod 100 in 3..6').to_ruby
  end

  def test_compiles_n_within_0_2
    assert_equal 'n.to_f.between?(0, 2)', Cldr::Export::Data::Plurals::Rule.parse('n within 0..2').to_ruby
  end

  def test_compiles_n_list_range
    assert_equal '(![30, 34, 39].include?(n.to_f % 100) || (((n.to_f % 100) % 1).zero? && (!(10..19).include?(n.to_f % 100) || !(90..99).include?(n.to_f % 100))))', Cldr::Export::Data::Plurals::Rule.parse('n % 100 != 10..19,30,34,39,90..99').to_ruby
  end

  def test_compiles_n_list_range2
    assert_equal '((n.to_f % 100) != 100 || (((n.to_f % 100) % 1).zero? && (!(10..19).include?(n.to_f % 100) || !(90..99).include?(n.to_f % 100))))', Cldr::Export::Data::Plurals::Rule.parse('n % 100 != 10..19,90..99,100').to_ruby
  end

  def test_eval_n_in
    n = 3.3
    assert_equal false, eval(Cldr::Export::Data::Plurals::Rule.parse('n mod 100 in 3..6').to_ruby, binding)
  end
end