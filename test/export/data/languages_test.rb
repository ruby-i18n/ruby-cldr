# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__) + '/../../test_helper'))

class TestCldrDataLanguages < Test::Unit::TestCase
  test 'languages :de' do
    codes = [:aa, :ab, :ace, :ach, :ada, :ady, :ae, :af, :afa, :afh, :agq,
             :ain, :ak, :akk, :ale, :alg, :alt, :am, :an, :ang, :anp, :apa,
             :ar, :"ar-001", :arc, :arn, :arp, :art, :arw, :as, :asa, :ast,
             :ath, :aus, :av, :awa, :ay, :az, :ba, :bad, :bai, :bal, :ban,
             :bas, :bat, :bax, :bbj, :be, :bej, :bem, :ber, :bez, :bfd, :bg,
             :bh, :bho, :bi, :bik, :bin, :bkm, :bla, :bm, :bn, :bnt, :bo, :br,
             :bra, :brx, :bs, :bss, :btk, :bua, :bug, :bum, :byn, :byv, :ca,
             :cad, :cai, :car, :cau, :cay, :cch, :ce, :ceb, :cel, :cgg, :ch,
             :chb, :chg, :chk, :chm, :chn, :cho, :chp, :chr, :chy, :ckb, :cmc,
             :co, :cop, :cpe, :cpf, :cpp, :cr, :crh, :crp, :cs, :csb, :cu,
             :cus, :cv, :cy, :da, :dak, :dar, :dav, :day, :de, :"de-AT",
             :"de-CH", :del, :den, :dgr, :din, :dje, :doi, :dra, :dsb, :dua,
             :dum, :dv, :dyo, :dyu, :dz, :dzg, :ebu, :ee, :efi, :egy, :eka,
             :el, :elx, :en, :"en-AU", :"en-CA", :"en-GB", :"en-US", :enm, :eo,
             :es, :"es-419", :"es-ES", :"es-MX", :et, :eu, :ewo, :fa, :fan,
             :fat, :ff, :fi, :fil, :fiu, :fj, :fo, :fon, :fr, :"fr-CA", :"fr-CH",
             :frm, :fro, :frr, :frs, :fur, :fy, :ga, :gaa, :gay, :gba, :gd, :gem,
             :gez, :gil, :gl, :gmh, :gn, :goh, :gon, :gor, :got, :grb, :grc,
             :gsw,  :gu, :guz, :gv, :gwi, :ha, :hai, :haw, :he, :hi, :hil, :him,
             :hit,  :hmn, :ho, :hr, :hsb, :ht, :hu, :hup, :hy, :hz, :ia, :iba,
             :ibb, :id, :ie, :ig, :ii, :ijo, :ik, :ilo, :inc, :ine, :inh, :io,
             :ira,  :iro, :is, :it, :iu, :ja, :jbo, :jmc, :jpr, :jrb, :jv, :ka,
             :kaa,  :kab, :kac, :kaj, :kam, :kar, :kaw, :kbd, :kbl, :kcg, :kde,
             :kea, :kfo, :kg, :kha, :khi, :kho, :khq, :ki, :kj, :kk, :kkj, :kl,
             :kln, :km, :kmb, :kn, :ko, :kok, :kos, :kpe, :kr, :krc, :krl, :kro,
             :kru, :ks, :ksb, :ksf, :ksh, :ku, :kum, :kut, :kv, :kw, :ky, :la,
             :lad, :lag, :lah, :lam, :lb, :lez, :lg, :li, :ln, :lo, :lol, :loz,
             :lt, :lu, :lua, :lui, :lun, :luo, :lus, :luy, :lv, :mad, :maf, :mag,
             :mai, :mak, :man, :map, :mas, :mde, :mdf, :mdr, :men, :mer, :mfe,
             :mg, :mga, :mgh, :mh, :mi, :mic, :min, :mis, :mk, :mkh, :ml, :mn,
             :mnc, :mni, :mno, :mo, :moh, :mos, :mr, :ms, :mt, :mua, :mul, :mun,
             :mus, :mwl, :mwr, :my, :mye, :myn, :myv, :na, :nah, :nai, :nap, :naq,
             :nb, :nd, :nds, :ne, :new, :ng, :nia, :nic, :niu, :nl, :"nl-BE", :nmg,
             :nn, :nnh, :no, :nog, :non, :nqo, :nr, :nso, :nub, :nus, :nv, :nwc,
             :ny, :nym, :nyn, :nyo, :nzi, :oc, :oj, :om,  :or, :os, :osa, :ota,
             :oto, :pa, :paa, :pag, :pal, :pam, :pap, :pau, :peo, :phi, :phn, :pi,
             :pl, :pon, :pra, :pro, :ps, :pt, :"pt-BR", :"pt-PT", :qu, :raj, :rap,
             :rar, :rm, :rn, :ro, :roa, :rof, :rom,  :root, :ru, :rup, :rw, :rwk,
             :sa, :sad, :sah, :sai, :sal, :sam,  :saq, :sas, :sat, :sba, :sbp, :sc,
             :scn, :sco, :sd, :se, :see, :seh, :sel, :sem, :ses, :sg, :sga, :sgn,
             :sh, :shi, :shn, :shu, :si, :sid, :sio, :sit, :sk, :sl, :sla, :sm,
             :sma, :smi, :smj, :smn, :sms, :sn, :snk, :so, :sog, :son, :sq, :sr,
             :srn, :srr, :ss, :ssa, :ssy, :st,  :su, :suk, :sus, :sux, :sv, :sw,
             :swb, :swc, :syc, :syr, :ta, :tai, :te, :tem, :teo, :ter, :tet, :tg,
             :th, :ti, :tig, :tiv, :tk, :tkl, :tl, :tlh, :tli, :tmh, :tn, :to, :tog,
             :tpi, :tr, :trv, :ts, :tsi,  :tt, :tum, :tup, :tut, :tvl, :tw, :twq,
             :ty, :tyv, :tzm, :udm, :ug, :uga, :uk, :umb, :und, :ur, :uz, :vai, :ve,
             :vi, :vo, :vot, :vun, :wa, :wae, :wak, :wal, :war, :was, :wen, :wo, :xal,
             :xh, :xog, :yao, :yap, :yav, :ybb, :yi, :yo, :ypk, :yue, :za, :zap, :zbl,
             :zen, :zgh, :zh, :"zh-Hans", :"zh-Hant", :znd, :zu, :zun, :zxx, :zza]

    languages = Cldr::Export::Data::Languages.new('de')[:languages]
    assert (languages.keys - codes).empty? && (codes - languages.keys).empty?
    assert_equal('Deutsch', languages[:de])
  end

  # Cldr::Export::Data.locales.each do |locale|
  #   test "extract languages for #{locale}" do
  #     assert_nothing_raised do
  #       Cldr::Export::Data::Languages.new(locale)
  #     end
  #   end
  # end
end

