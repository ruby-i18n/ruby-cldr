# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__) + '/../../test_helper'))

class TestCldrDataTimezones < Test::Unit::TestCase
  test 'timezones :de' do
    codes = [:"Etc/Unknown", :"Europe/Tirane", :"Asia/Yerevan",
             :"Antarctica/South_Pole", :"Antarctica/Vostok",
             :"Antarctica/DumontDUrville", :"Europe/Vienna", :"Europe/Brussels",
             :"Africa/Ouagadougou", :"Africa/Porto-Novo", :"America/St_Barthelemy",
             :"Atlantic/Bermuda", :"America/Sao_Paulo", :"America/Coral_Harbour",
             :"America/St_Johns", :"Europe/Zurich", :"Pacific/Easter",
             :"Asia/Kashgar", :"America/Bogota", :"America/Havana",
             :"Atlantic/Cape_Verde", :"America/Curacao", :"Indian/Christmas",
             :"Asia/Nicosia", :"Europe/Prague", :"Europe/Busingen",
             :"Africa/Djibouti", :"Europe/Copenhagen", :"Africa/Algiers",
             :"Africa/Cairo", :"Africa/El_Aaiun", :"Africa/Asmera",
             :"Atlantic/Canary", :"Africa/Addis_Ababa", :"Pacific/Fiji",
             :"Pacific/Truk", :"Pacific/Ponape", :"Atlantic/Faeroe",
             :"Europe/London", :"Asia/Tbilisi", :"Africa/Accra", :"America/Godthab",
             :"America/Scoresbysund", :"Europe/Athens", :"Atlantic/South_Georgia",
             :"Asia/Hong_Kong", :"Asia/Jayapura", :"Europe/Dublin", :"Asia/Calcutta",
             :"Asia/Baghdad", :"Asia/Tehran", :"Atlantic/Reykjavik", :"Europe/Rome",
             :"America/Jamaica", :"Asia/Tokyo", :"Asia/Bishkek", :"Indian/Comoro",
             :"America/St_Kitts", :"Asia/Pyongyang", :"America/Cayman",
             :"Asia/Aqtobe", :"America/St_Lucia", :"Europe/Vilnius",
             :"Europe/Luxembourg", :"Africa/Tripoli", :"Europe/Chisinau",
             :"Asia/Macau", :"Indian/Maldives", :"America/Mexico_City",
             :"Asia/Katmandu", :"Asia/Muscat", :"Europe/Warsaw", :"Atlantic/Azores",
             :"Europe/Lisbon", :"America/Asuncion", :"Asia/Qatar", :"Indian/Reunion",
             :"Europe/Bucharest", :"Europe/Belgrade", :"Europe/Moscow",
             :"Europe/Volgograd", :"Asia/Yekaterinburg", :"Asia/Novosibirsk",
             :"Asia/Novokuznetsk", :"Asia/Krasnoyarsk", :"Asia/Yakutsk",
             :"Asia/Vladivostok", :"Asia/Sakhalin", :"Asia/Kamchatka",
             :"Asia/Riyadh", :"Africa/Khartoum", :"Asia/Singapore",
             :"Atlantic/St_Helena", :"Africa/Mogadishu", :"Africa/Sao_Tome",
             :"America/El_Salvador", :"America/Lower_Princes", :"Asia/Damascus",
             :"Africa/Lome", :"Asia/Dushanbe", :"America/Port_of_Spain",
             :"Asia/Taipei", :"Africa/Dar_es_Salaam", :"Europe/Uzhgorod",
             :"Europe/Kiev", :"Europe/Zaporozhye", :"America/North_Dakota/Beulah",
             :"America/North_Dakota/New_Salem", :"America/North_Dakota/Center",
             :"America/Indiana/Vincennes", :"America/Indiana/Petersburg",
             :"America/Indiana/Tell_City", :"America/Indiana/Knox",
             :"America/Indiana/Winamac", :"America/Indiana/Marengo",
             :"America/Indiana/Vevay", :"America/Kentucky/Monticello",
             :"Asia/Tashkent", :"Europe/Vatican", :"America/St_Vincent",
             :"America/St_Thomas", :"Asia/Saigon"]

    timezones = Cldr::Export::Data::Timezones.new(:de)[:timezones]
    assert (timezones.keys - codes).empty? && (codes - timezones.keys).empty?
    assert_equal({ :city => 'Wien' }, timezones[:"Europe/Vienna"])
  end

  # Cldr::Export::Data.locales.each do |locale|
  #   test "extract timezones for #{locale}" do
  #     assert_nothing_raised do
  #       Cldr::Export::Data::Timezones.new(locale)
  #     end
  #   end
  # end
end






