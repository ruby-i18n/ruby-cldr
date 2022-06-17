# frozen_string_literal: true

require File.join(File.expand_path(File.dirname(__FILE__)), "../../test_helper")

class TestCldrDataPluralParser < Test::Unit::TestCase
  def cldr_rules
    Cldr::Export::Data::Plurals::Rules.read(Cldr::Export::Data::RAW_DATA[nil])
  end

  test "compiles to valid ruby code" do
    assert_nothing_raised { eval(cldr_rules.to_ruby) } # rubocop:disable Security/Eval
  end

  test "evals to a hash containing plural rule and keys per locale" do
    data = eval(cldr_rules.to_ruby) # rubocop:disable Security/Eval
    assert(Hash === data)
    assert(Proc === data[:de][:i18n][:plural][:rule])
    assert_equal([:one, :other], data[:de][:i18n][:plural][:keys])
  end

  test "lookup rule by locale" do
    assert_equal('lambda { |n| n = n.respond_to?(:abs) ? n.abs : ((m = n.to_s)[0] == "-" ? m[1,m.length] : m); (n.to_i == 1 && ((v = n.to_s.split(".")[1]) ? v.length : 0) == 0) ? :one : :other }', cldr_rules[:de].to_ruby)
  end

  test "parses empty" do
    assert(Cldr::Export::Data::Plurals::Rule.parse("").is_a?(Cldr::Export::Data::Plurals::Expression))
    assert(Cldr::Export::Data::Plurals::Rule.parse(" ").is_a?(Cldr::Export::Data::Plurals::Expression))
    assert(Cldr::Export::Data::Plurals::Rule.parse(" @integer").is_a?(Cldr::Export::Data::Plurals::Expression))
    assert(Cldr::Export::Data::Plurals::Rule.parse("@decimal").is_a?(Cldr::Export::Data::Plurals::Expression))
  end

  test "parses n is 1" do
    rule = Cldr::Export::Data::Plurals::Rule.parse("n is 1")
    assert_equal([:is, 1], [rule.operator, rule.operand])
  end

  test "parses n mod 1 is 1" do
    rule = Cldr::Export::Data::Plurals::Rule.parse("n mod 1 is 1")
    assert_equal([:is, 1, "1", "n"], [rule.operator, rule.operand, rule.mod, rule.type])
  end

  test "parses n is not 1" do
    rule = Cldr::Export::Data::Plurals::Rule.parse("n is not 1")
    assert_equal([:is, 1, true, "n"], [rule.operator, rule.operand, rule.negate, rule.type])
  end

  test "parses n mod 1 is not 1" do
    rule = Cldr::Export::Data::Plurals::Rule.parse("n mod 1 is not 1")
    assert_equal([:is, 1, true, "1", "n"], [rule.operator, rule.operand, rule.negate, rule.mod, rule.type])
  end

  test "parses n in 1 2" do
    rule = Cldr::Export::Data::Plurals::Rule.parse("n in 1..2")
    assert_equal([:in, [[], [1..2]], "n"], [rule.operator, rule.operand, rule.type])
  end

  test "parses n mod 1 in 1 2" do
    rule = Cldr::Export::Data::Plurals::Rule.parse("n mod 1 in 1..2")
    assert_equal([:in, [[], [1..2]], "1", "n"], [rule.operator, rule.operand, rule.mod, rule.type])
  end

  test "parses n not in 1 2" do
    rule = Cldr::Export::Data::Plurals::Rule.parse("n not in 1..2")
    assert_equal([:in, [[], [1..2]], true, "n"], [rule.operator, rule.operand, rule.negate, rule.type])
  end

  test "parses n mod 1 not in 1 2" do
    rule = Cldr::Export::Data::Plurals::Rule.parse("n mod 1 not in 1..2")
    assert_equal([:in, [[], [1..2]], true, "1", "n"], [rule.operator, rule.operand, rule.negate, rule.mod, rule.type])
  end

  test "parses n within 0 2" do
    expression = Cldr::Export::Data::Plurals::Rule.parse("n within 0..2")
    assert_equal([:within, 0..2, "n"], [expression.operator, expression.operand, expression.type])
  end

  test "parses n list range" do
    expression = Cldr::Export::Data::Plurals::Rule.parse("n % 100 != 10..19,30,34,39,90..99")
    assert_equal([:in, [[30, 34, 39], [10..19, 90..99]], true, "100", "n"], [expression.operator, expression.operand, expression.negate, expression.mod, expression.type])
  end

  test "parses or condition" do
    rule = Cldr::Export::Data::Plurals::Rule.parse("n mod 1 is not 2 or n mod 2 in 3..4")
    assert_equal(2, rule.size)
    assert_equal([:is, 2, true, "1", "n"], [rule[0].operator, rule[0].operand, rule[0].negate, rule[0].mod, rule[0].type])
    assert_equal([:in, [[], [3..4]], false, "2", "n"], [rule[1].operator, rule[1].operand, rule[1].negate, rule[1].mod, rule[1].type])
  end

  test "parses and condition" do
    rule = Cldr::Export::Data::Plurals::Rule.parse("n mod 1 is not 2 and n mod 2 in 3..4")
    assert_equal(2, rule.size)
    assert_equal([:is, 2, true, "1", "n"], [rule[0].operator, rule[0].operand, rule[0].negate, rule[0].mod, rule[0].type])
    assert_equal([:in, [[], [3..4]], false, "2", "n"], [rule[1].operator, rule[1].operand, rule[1].negate, rule[1].mod, rule[1].type])
  end

  test "parses and priority" do
    rule = Cldr::Export::Data::Plurals::Rule.parse("i = 0 or v != 1 and f % 2 = 3..4")
    assert_equal(2, rule.size)
    assert_equal(2, rule[1].size)
    assert_equal([:is, 0, "i"], [rule[0].operator, rule[0].operand, rule[0].type])
    assert_equal([:is, 1, true, "v"], [rule[1][0].operator, rule[1][0].operand, rule[1][0].negate, rule[1][0].type])
    assert_equal([:in, [[], [3..4]], "2", "f"], [rule[1][1].operator, rule[1][1].operand, rule[1][1].mod, rule[1][1].type])
  end

  test "parse fails when given unknown operand" do
    exc = assert_raises do
      Cldr::Export::Data::Plurals::Rule.parse("q = 0")
    end
    assert_equal("can not parse 'q = 0'", exc.message)
  end

  test "compiles empty" do
    assert_equal(nil, Cldr::Export::Data::Plurals::Rule.parse("").to_ruby)
    assert_equal(nil, Cldr::Export::Data::Plurals::Rule.parse(" ").to_ruby)
    assert_equal(nil, Cldr::Export::Data::Plurals::Rule.parse(" @integer").to_ruby)
    assert_equal(nil, Cldr::Export::Data::Plurals::Rule.parse("@decimal").to_ruby)
  end

  test "compiles n is 2" do
    assert_equal("n.to_f == 2", Cldr::Export::Data::Plurals::Rule.parse("n is 2").to_ruby)
  end

  test "compiles n mod 1 is 2" do
    assert_equal("n.to_f % 1 == 2", Cldr::Export::Data::Plurals::Rule.parse("n mod 1 is 2").to_ruby)
  end

  test "compiles n is not 2" do
    assert_equal("n.to_f != 2", Cldr::Export::Data::Plurals::Rule.parse("n is not 2").to_ruby)
  end

  test "compiles n mod 1 is not 2" do
    assert_equal("n.to_f % 1 != 2", Cldr::Export::Data::Plurals::Rule.parse("n mod 1 is not 2").to_ruby)
  end

  test "compiles n in 1 2" do
    assert_equal("((n.to_f % 1).zero? && (1..2).include?(n.to_f))", Cldr::Export::Data::Plurals::Rule.parse("n in 1..2").to_ruby)
  end

  test "compiles n mod 1 in 1 2" do
    assert_equal("(((n.to_f % 1) % 1).zero? && (1..2).include?(n.to_f % 1))", Cldr::Export::Data::Plurals::Rule.parse("n mod 1 in 1..2").to_ruby)
  end

  test "compiles n not in 1 2" do
    assert_equal("((n.to_f % 1).zero? && !(1..2).include?(n.to_f))", Cldr::Export::Data::Plurals::Rule.parse("n not in 1..2").to_ruby)
  end

  test "compiles n mod 1 not in 1 2" do
    assert_equal("(((n.to_f % 1) % 1).zero? && !(1..2).include?(n.to_f % 1))", Cldr::Export::Data::Plurals::Rule.parse("n mod 1 not in 1..2").to_ruby)
  end

  test "compiles or condition" do
    assert_equal("(n.to_f % 1 != 2 || (((n.to_f % 2) % 1).zero? && (3..4).include?(n.to_f % 2)))", Cldr::Export::Data::Plurals::Rule.parse("n mod 1 is not 2 or n mod 2 in 3..4").to_ruby)
  end

  test "compiles and condition" do
    assert_equal("(n.to_f % 1 != 2 && (((n.to_f % 2) % 1).zero? && (3..4).include?(n.to_f % 2)))", Cldr::Export::Data::Plurals::Rule.parse("n mod 1 is not 2 and n mod 2 in 3..4").to_ruby)
  end

  test "compiles and priority" do
    assert_equal('(n.to_i == 0 || (((v = n.to_s.split(".")[1]) ? v.length : 0) != 1 && (3..4).include?(((t = n.to_s.split(".")[1]) ? t.gsub(/0+$/, "").to_i : 0) % 2)))', Cldr::Export::Data::Plurals::Rule.parse("i = 0 or v != 1 and t mod 2 = 3..4").to_ruby)
  end

  test "compiles n mod 100 in 3 99" do
    assert_equal("(((n.to_f % 100) % 1).zero? && (3..6).include?(n.to_f % 100))", Cldr::Export::Data::Plurals::Rule.parse("n mod 100 in 3..6").to_ruby)
  end

  test "compiles n within 0 2" do
    assert_equal("n.to_f.between?(0, 2)", Cldr::Export::Data::Plurals::Rule.parse("n within 0..2").to_ruby)
  end

  test "compiles n list range" do
    assert_equal("(![30, 34, 39].include?(n.to_f % 100) || (((n.to_f % 100) % 1).zero? && (!(10..19).include?(n.to_f % 100) || !(90..99).include?(n.to_f % 100))))", Cldr::Export::Data::Plurals::Rule.parse("n % 100 != 10..19,30,34,39,90..99").to_ruby)
  end

  test "compiles n list range2" do
    assert_equal("((n.to_f % 100) != 100 || (((n.to_f % 100) % 1).zero? && (!(10..19).include?(n.to_f % 100) || !(90..99).include?(n.to_f % 100))))", Cldr::Export::Data::Plurals::Rule.parse("n % 100 != 10..19,90..99,100").to_ruby)
  end

  test "compiles e operand as always 0" do
    assert_equal("((e = 0) == 0 || !(0..5).include?(e = 0))", Cldr::Export::Data::Plurals::Rule.parse("e = 0 or e != 0..5").to_ruby)
  end

  test "eval n in" do
    n = 3.3
    assert_equal(false, eval(Cldr::Export::Data::Plurals::Rule.parse("n mod 100 in 3..6").to_ruby, binding)) # rubocop:disable Security/Eval
  end

  test "codes with missing spaces" do
    assert_equal("n.to_f % 100 == 0", Cldr::Export::Data::Plurals::Rule.parse("n%100 = 0").to_ruby)
    assert_equal("n.to_f % 100 == 0", Cldr::Export::Data::Plurals::Rule.parse("n % 100=0").to_ruby)
    assert_equal("n.to_f != 0", Cldr::Export::Data::Plurals::Rule.parse("n!=0").to_ruby)
  end

  test "n negative" do
    # one: i = 1 and v = 0 @integer 1
    # other: @integer 0, 2~16, 100, 1000, 10000, 100000, 1000000, … @decimal 0.0~1.5, 10.0, 100.0, 1000.0, 10000.0, 100000.0, 1000000.0, …
    fn = eval(cldr_rules[:de].to_ruby) # rubocop:disable Security/Eval
    assert_equal(:one, fn.call(-1))
    assert_equal(:one, fn.call("-1"))
    assert_equal(:one, fn.call(1))
    assert_equal(:other, fn.call("1.0"))
    assert_equal(:other, fn.call("-1.0"))
    assert_equal(:other, fn.call(-5))
  end

  test "n digit" do
    # one: n = 0..1 or n = 11..99 @integer 0, 1, 11~24 @decimal 0.0, 1.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 20.0, 21.0, 22.0, 23.0, 24.0
    # other: @integer 2~10, 100~106, 1000, 10000, 100000, 1000000, … @decimal 0.1~0.9, 1.1~1.7, 10.0, 100.0, 1000.0, 10000.0, 100000.0, 1000000.0, …
    fn = eval(cldr_rules[:tzm].to_ruby) # rubocop:disable Security/Eval
    assert_equal(:one, fn.call(0))
    assert_equal(:one, fn.call(1))
    assert_equal(:one, fn.call(11))
    assert_equal(:one, fn.call(25.0))
    assert_equal(:one, fn.call("-62.00"))
    assert_equal(:other, fn.call(2))
    assert_equal(:other, fn.call(10))
    assert_equal(:other, fn.call(25.1))
    assert_equal(:other, fn.call(111))
  end

  test "n string" do
    # one: i = 1 and v = 0 or i = 0 and t = 1 @integer 1 @decimal 0.1, 0.01, 0.10, 0.001, 0.010, 0.100, 0.0001, 0.0010, 0.0100, 0.1000
    # other: @integer 0, 2~16, 100, 1000, 10000, 100000, 1000000, … @decimal 0.0, 0.2~1.6, 10.0, 100.0, 1000.0, 10000.0, 100000.0, 1000000.0, …
    fn = eval(cldr_rules[:pt].to_ruby) # rubocop:disable Security/Eval
    assert_equal(:one, fn.call("1"))
    assert_equal(:one, fn.call("0.00100"))
    assert_equal(:one, fn.call("-0.01"))
    assert_equal(:one, fn.call("0"))
    assert_equal(:one, fn.call("1.1"))
    assert_equal(:one, fn.call("0.21"))
    assert_equal(:other, fn.call("2"))
  end

  test "n mod" do
    # one: v = 0 and i % 10 = 1 and i % 100 != 11 or f % 10 = 1 and f % 100 != 11 @integer 1, 21, 31, 41, 51, 61, 71, 81, 101, 1001, … @decimal 0.1, 1.1, 2.1, 3.1, 4.1, 5.1, 6.1, 7.1, 10.1, 100.1, 1000.1, …
    # few: v = 0 and i % 10 = 2..4 and i % 100 != 12..14 or f % 10 = 2..4 and f % 100 != 12..14 @integer 2~4, 22~24, 32~34, 42~44, 52~54, 62, 102, 1002, … @decimal 0.2~0.4, 1.2~1.4, 2.2~2.4, 3.2~3.4, 4.2~4.4, 5.2, 10.2, 100.2, 1000.2, …
    # other: @integer 0, 5~19, 100, 1000, 10000, 100000, 1000000, … @decimal 0.0, 0.5~1.0, 1.5~2.0, 2.5~2.7, 10.0, 100.0, 1000.0, 10000.0, 100000.0, 1000000.0, …
    fn = eval(cldr_rules[:hr].to_ruby) # rubocop:disable Security/Eval
    assert_equal(:one, fn.call(1))
    assert_equal(:one, fn.call("21"))
    assert_equal(:one, fn.call("131"))
    assert_equal(:one, fn.call(11.321))
    assert_equal(:one, fn.call("25.01"))
    assert_equal(:few, fn.call(24))
    assert_equal(:few, fn.call("252"))
    assert_equal(:few, fn.call(2.04))
    assert_equal(:few, fn.call("113.0022"))
    assert_equal(:other, fn.call("10"))
    assert_equal(:other, fn.call("11"))
    assert_equal(:other, fn.call(311))
    assert_equal(:other, fn.call("13"))
    assert_equal(:other, fn.call(1212))
    assert_equal(:other, fn.call("0.10"))
    assert_equal(:other, fn.call(0.11))
    assert_equal(:other, fn.call("0.220"))
    assert_equal(:other, fn.call("41.0"))
  end

  test "e operand" do
    # one: i = 0,1 @integer 0, 1 @decimal 0.0~1.5
    # many: e = 0 and i != 0 and i % 1000000 = 0 and v = 0 or e != 0..5 @integer 1000000, 1c6, 2c6, 3c6, 4c6, 5c6, 6c6, … @decimal 1.0000001c6, 1.1c6, 2.0000001c6, 2.1c6, 3.0000001c6, 3.1c6, …
    # other: @integer 2~17, 100, 1000, 10000, 100000, 1c3, 2c3, 3c3, 4c3, 5c3, 6c3, … @decimal 2.0~3.5, 10.0, 100.0, 1000.0, 10000.0, 100000.0, 1000000.0, 1.0001c3, 1.1c3, 2.0001c3, 2.1c3, 3.0001c3, 3.1c3, …
    fn = eval(cldr_rules[:fr].to_ruby) # rubocop:disable Security/Eval
    assert_equal(:one, fn.call(0))
    assert_equal(:one, fn.call(1))
    assert_equal(:many, fn.call(1000000))
    assert_equal(:many, fn.call(2000000))
    assert_equal(:other, fn.call(1000001))
    assert_equal(:other, fn.call(1000000.0))
  end
end
