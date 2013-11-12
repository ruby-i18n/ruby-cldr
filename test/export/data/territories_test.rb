# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__) + '/../../test_helper'))

class TestCldrDataTerritories < Test::Unit::TestCase
  test 'territories :de' do
    codes = [:"001", :"002", :"003", :"005", :"009", :"011", :"013", :"014",
             :"015", :"017", :"018", :"019", :"021", :"029", :"030", :"034",
             :"035", :"039", :"053", :"054", :"057", :"061", :"142", :"143",
             :"145", :"150", :"151", :"154", :"155", :"419", :AC, :AD, :AE,
             :AF, :AG, :AI, :AL, :AM, :AN, :AO, :AQ, :AR, :AS, :AT, :AU, :AW,
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
             :TZ, :UA, :UG, :UM, :US, :UY, :UZ, :VA, :VC, :VE, :VG, :VI, :VN,
             :VU, :WF, :WS, :XK, :YE, :YT, :ZA, :ZM, :ZW, :ZZ]

    territories = Cldr::Export::Data::Territories.new(:de)[:territories]
    assert (territories.keys - codes).empty? && (codes - territories.keys).empty?
    assert_equal('Deutschland', territories[:DE])
  end

  # Cldr::Export::Data.locales.each do |locale|
  #   test "extract territories for #{locale}" do
  #     assert_nothing_raised do
  #       Cldr::Export::Data::Territories.new(locale)
  #     end
  #   end
  # end
end







