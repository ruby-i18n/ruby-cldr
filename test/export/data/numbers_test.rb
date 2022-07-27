# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../../test_helper"))

class TestCldrDataNumbers < Test::Unit::TestCase
  test "number symbols :de" do
    expected = {
      approximately_sign: "≈",
      decimal: ",",
      exponential: "E",
      group: ".",
      infinity: "∞",
      list: ";",
      minus_sign: "-",
      nan: "NaN",
      per_mille: "‰",
      percent_sign: "%",
      plus_sign: "+",
      superscripting_exponent: "·",
      time_separator: ":",
    }
    assert_equal expected, Cldr::Export::Data::Numbers.new(:de)[:numbers][:latn][:symbols]
  end

  test "number formats :de" do
    expected = {
      currency: {
        patterns: {
          default: {
            accounting: "#,##0.00 ¤",
            standard: "#,##0.00 ¤",
          },
          short: {
            standard: {
              "1000": { one: "0", other: "0" },
              "10000": { one: "0", other: "0" },
              "100000": { one: "0", other: "0" },
              "1000000": { one: "0 Mio'.' ¤", other: "0 Mio'.' ¤" },
              "10000000": { one: "00 Mio'.' ¤", other: "00 Mio'.' ¤" },
              "100000000": { one: "000 Mio'.' ¤", other: "000 Mio'.' ¤" },
              "1000000000": { one: "0 Mrd'.' ¤", other: "0 Mrd'.' ¤" },
              "10000000000": { one: "00 Mrd'.' ¤", other: "00 Mrd'.' ¤" },
              "100000000000": { one: "000 Mrd'.' ¤", other: "000 Mrd'.' ¤" },
              "1000000000000": { one: "0 Bio'.' ¤", other: "0 Bio'.' ¤" },
              "10000000000000": { one: "00 Bio'.' ¤", other: "00 Bio'.' ¤" },
              "100000000000000": { one: "000 Bio'.' ¤", other: "000 Bio'.' ¤" },
            },
          },
        },
        unit: { one: "{0} {1}", other: "{0} {1}" },
      },
      decimal: {
        patterns: {
          default: {
            standard: "#,##0.###",
          },
          long: {
            standard: {
              "1000": { one: "0 Tausend", other: "0 Tausend" },
              "10000": { one: "00 Tausend", other: "00 Tausend" },
              "100000": { one: "000 Tausend", other: "000 Tausend" },
              "1000000": { one: "0 Million", other: "0 Millionen" },
              "10000000": { one: "00 Millionen", other: "00 Millionen" },
              "100000000": { one: "000 Millionen", other: "000 Millionen" },
              "1000000000": { one: "0 Milliarde", other: "0 Milliarden" },
              "10000000000": { one: "00 Milliarden", other: "00 Milliarden" },
              "100000000000": { one: "000 Milliarden", other: "000 Milliarden" },
              "1000000000000": { one: "0 Billion", other: "0 Billionen" },
              "10000000000000": { one: "00 Billionen", other: "00 Billionen" },
              "100000000000000": { one: "000 Billionen", other: "000 Billionen" },
            },
          },
          short: {
            standard: {
              "1000": { one: "0", other: "0" },
              "10000": { one: "0", other: "0" },
              "100000": { one: "0", other: "0" },
              "1000000": { one: "0 Mio'.'", other: "0 Mio'.'" },
              "10000000": { one: "00 Mio'.'", other: "00 Mio'.'" },
              "100000000": { one: "000 Mio'.'", other: "000 Mio'.'" },
              "1000000000": { one: "0 Mrd'.'", other: "0 Mrd'.'" },
              "10000000000": { one: "00 Mrd'.'", other: "00 Mrd'.'" },
              "100000000000": { one: "000 Mrd'.'", other: "000 Mrd'.'" },
              "1000000000000": { one: "0 Bio'.'", other: "0 Bio'.'" },
              "10000000000000": { one: "00 Bio'.'", other: "00 Bio'.'" },
              "100000000000000": { one: "000 Bio'.'", other: "000 Bio'.'" },
            },
          },
        },
      },
      percent: { patterns: { default: { standard: "#,##0 %" } } },
      scientific: { patterns: { default: { standard: "#E0" } } },
    }
    assert_equal expected, Cldr::Export::Data::Numbers.new(:de)[:numbers][:latn][:formats]
  end

  test "redirects in root locale" do
    assert_equal :"numbers.latn.formats.decimal.patterns.short",
      Cldr::Export::Data::Numbers.new(:root)[:numbers][:latn][:formats][:decimal][:patterns][:long]
  end
end
