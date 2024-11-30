# encoding: utf-8
# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__) + "/../../test_helper"))

class TestCldrDataTerritories < Test::Unit::TestCase
  test "territories :de" do
    # rubocop:disable Layout/MultilineArrayLineBreaks
    codes = [ # rubocop:disable Metrics/CollectionLiteralLength
      :"001", :"002", :"003", :"005", :"009", :"011", :"013", :"014",
      :"015", :"017", :"018", :"019", :"021", :"029", :"030", :"034",
      :"035", :"039", :"053", :"054", :"057", :"061", :"142", :"143",
      :"145", :"150", :"151", :"154", :"155", :"202", :"419", :AC, :AD,
      :AE, :AF, :AG, :AI, :AL, :AM, :AO, :AQ, :AR, :AS, :AT, :AU, :AW,
      :AX, :AZ, :BA, :BB, :BD, :BE, :BF, :BG, :BH, :BI, :BJ, :BL, :BM,
      :BN, :BO, :BQ, :BR, :BS, :BT, :BV, :BW, :BY, :BZ, :CA, :CC, :CD,
      :CF, :CG, :CH, :CI, :CK, :CL, :CM, :CN, :CO, :CP, :CR, :CU, :CV,
      :CW, :CX, :CY, :CZ, :DE, :DG, :DJ, :DK, :DM, :DO, :DZ, :EA, :EC,
      :EE, :EG, :EH, :ER, :ES, :ET, :EU, :FI, :FJ, :FK, :FM, :FO, :FR,
      :GA, :GB, :GD, :GE, :GF, :GG, :GH, :GI, :GL, :GM, :GN, :GP, :GQ,
      :GR, :GS, :GT, :GU, :GW, :GY, :HK, :HM, :HN, :HR, :HT, :HU, :IC,
      :ID, :IE, :IL, :IM, :IN, :IO, :IQ, :IR, :IS, :IT, :JE, :JM, :JO,
      :JP, :KE, :KG, :KH, :KI, :KM, :KN, :KP, :KR, :KW, :KY, :KZ, :LA,
      :LB, :LC, :LI, :LK, :LR, :LS, :LT, :LU, :LV, :LY, :MA, :MC, :MD,
      :ME, :MF, :MG, :MH, :MK, :ML, :MM, :MN, :MO, :MP, :MQ, :MR, :MS,
      :MT, :MU, :MV, :MW, :MX, :MY, :MZ, :NA, :NC, :NE, :NF, :NG, :NI,
      :NL, :NO, :NP, :NR, :NU, :NZ, :OM, :PA, :PE, :PF, :PG, :PH, :PK,
      :PL, :PM, :PN, :PR, :PS, :PT, :PW, :PY, :QA, :QO, :RE, :RO, :RS,
      :RU, :RW, :SA, :SB, :SC, :SD, :SE, :SG, :SH, :SI, :SJ, :SK, :SL,
      :SM, :SN, :SO, :SR, :SS, :ST, :SV, :SX, :SY, :SZ, :TA, :TC, :TD,
      :TF, :TG, :TH, :TJ, :TK, :TL, :TM, :TN, :TO, :TR, :TT, :TV, :TW,
      :TZ, :UA, :UG, :UN, :UM, :US, :UY, :UZ, :VA, :VC, :VE, :VG, :VI,
      :VN, :VU, :WF, :WS, :XA, :XB, :XK, :YE, :YT, :ZA, :ZM, :ZW, :ZZ,
      :EZ,
    ]
    # rubocop:enable Layout/MultilineArrayLineBreaks

    territories = Cldr::Export::Data::Territories.new(:de)[:territories]
    assert_empty codes - territories.keys, "Unexpected missing territories"
    assert_empty territories.keys - codes, "Unexpected extra territories"
    assert_equal("Deutschland", territories[:DE])
  end

  test "territories does not overwrite long form with the short one" do
    territories = Cldr::Export::Data::Territories.new(:en)[:territories]

    assert_equal "United States", territories[:US]
  end
end
