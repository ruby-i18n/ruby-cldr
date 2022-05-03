# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../../test_helper"))

class TestCldrCurrencies < Test::Unit::TestCase
  test "currencies :de" do
    codes = [:ADP, :AED, :AFA, :AFN, :ALL, :AMD, :ANG, :AOA, :AOK, :AON, :AOR,
             :ARA, :ARP, :ARS, :ATS, :AUD, :AWG, :AZM, :AZN, :BAD, :BAM, :BBD,
             :BDT, :BEC, :BEF, :BEL, :BGL, :BGN, :BHD, :BIF, :BMD, :BND, :BOB,
             :BOP, :BOV, :BRB, :BRC, :BRE, :BRL, :BRN, :BRR, :BRZ, :BSD, :BTN,
             :BUK, :BWP, :BYB, :BYR, :BZD, :CAD, :CDF, :CHE, :CHF, :CHW, :CLF,
             :CLP, :CNY, :COP, :CRC, :CSD, :CSK, :CUC, :CUP, :CVE, :CYP, :CZK,
             :DDM, :DEM, :DJF, :DKK, :DOP, :DZD, :ECS, :ECV, :EEK, :EGP, :ERN,
             :ESA, :ESB, :ESP, :ETB, :EUR, :FIM, :FJD, :FKP, :FRF, :GBP, :GEK,
             :GEL, :GHC, :GHS, :GIP, :GMD, :GNF, :GNS, :GQE, :GRD, :GTQ, :GWE,
             :GWP, :GYD, :HKD, :HNL, :HRD, :HRK, :HTG, :HUF, :IDR, :IEP, :ILP,
             :ILS, :INR, :IQD, :IRR, :ISK, :ITL, :JMD, :JOD, :JPY, :KES, :KGS,
             :KHR, :KMF, :KPW, :KRW, :KWD, :KYD, :KZT, :LAK, :LBP, :LKR, :LRD,
             :LSL, :LTL, :LTT, :LUC, :LUF, :LUL, :LVL, :LVR, :LYD, :MAD, :MAF,
             :MDL, :MGA, :MGF, :MKD, :MLF, :MMK, :MNT, :MOP, :MRO, :MTL, :MTP,
             :MUR, :MVR, :MWK, :MXN, :MXP, :MXV, :MYR, :MZE, :MZM, :MZN, :NAD,
             :NGN, :NIC, :NIO, :NLG, :NOK, :NPR, :NZD, :OMR, :PAB, :PEI, :PEN,
             :PES, :PGK, :PHP, :PKR, :PLN, :PLZ, :PTE, :PYG, :QAR, :RHD, :ROL,
             :RON, :RSD, :RUB, :RUR, :RWF, :SAR, :SBD, :SCR, :SDD, :SDG, :SDP,
             :SEK, :SGD, :SHP, :SIT, :SKK, :SLL, :SOS, :SRD, :SRG, :SSP, :STD,
             :SUR, :SVC, :SYP, :SZL, :THB, :TJR, :TJS, :TMM, :TMT, :TND, :TOP,
             :TPE, :TRL, :TRY, :TTD, :TWD, :TZS, :UAH, :UAK, :UGS, :UGX, :USD,
             :USN, :USS, :UYP, :UYU, :UZS, :VEB, :VEF, :VND, :VUV, :WST, :XAF,
             :XAG, :XAU, :XBA, :XBB, :XBC, :XBD, :XCD, :XDR, :XEU, :XFO, :XFU,
             :XOF, :XPD, :XPF, :XPT, :XRE, :XTS, :XXX, :YDD, :YER, :YUD, :YUM,
             :YUN, :ZAL, :ZAR, :ZMK, :ZMW, :ZRN, :ZRZ, :ZWD, :ZWL, :ZWR, :ALK,
             :ARL, :ARM, :BAN, :BGM, :BGO, :BOL, :CLE, :CNX, :COU, :ILR, :ISJ,
             :KRH, :KRO, :MCF, :MDC, :MKN, :MVP, :UYI, :VNN, :XSU, :XUA, :YUR,
             :BYN, :CNH, :MRU, :STN, :VES,]

    currencies = Cldr::Export::Data::Currencies.new(:de)[:currencies]
    assert_empty codes - currencies.keys, "Unexpected missing currencies"
    assert_empty currencies.keys - codes, "Unexpected extra currencies"
    assert_equal({ name: "Euro", "narrow_symbol": "€", one: "Euro", other: "Euro", symbol: "€" }, currencies[:EUR])
  end

  test "currencies populates symbol-narrow when narrow symbol is not equal to the regular symbol" do
    currencies = Cldr::Export::Data::Currencies.new(:root)[:currencies]
    assert_equal({ symbol: "US$", "narrow_symbol": "$" }, currencies[:USD])
  end
end
