# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__) + "/../../test_helper"))

class TestCldrDataLanguages < Test::Unit::TestCase
  test "languages :de" do
    codes = [:aa, :ab, :ace, :ach, :ada, :ady, :ae, :aeb, :af,
      :afh, :agq, :ain, :ak, :akk, :akz, :ale, :aln, :alt, :am,
      :an, :ang, :anp, :ar, :"ar-001", :arc, :arn, :aro, :arp,
      :arq, :ars, :arw, :ary, :arz, :as, :asa, :ase, :ast, :av,
      :avk, :awa, :ay, :az, :ba, :bal, :ban, :bar, :bas, :bax,
      :bbc, :bbj, :be, :bej, :bem, :bew, :bez, :bfd, :bfq, :bg,
      :bgn, :bho, :bi, :bik, :bin, :bjn, :bkm, :bla, :bm, :bn,
      :bo, :bpy, :bqi, :br, :bra, :brh, :brx, :bs, :bss, :bua,
      :bug, :bum, :byn, :byv, :ca, :cad, :car, :cay, :cch, :ce,
      :ceb, :cgg, :ch, :chb, :chg, :chk, :chm, :chn, :cho, :chp,
      :chr, :chy, :ckb, :co, :cop, :cps, :cr, :crh, :crs, :cs,
      :csb, :cu, :cv, :cy, :da, :dak, :dar, :dav, :de, :"de-AT",
      :"de-CH", :del, :den, :dgr, :din, :dje, :doi, :dsb, :dtp,
      :dua, :dum, :dv, :dyo, :dyu, :dz, :dzg, :ebu, :ee, :efi,
      :egl, :egy, :eka, :el, :elx, :en, :enm,
      :eo, :es, :esu, :et, :eu, :ewo, :ext, :fa, :fan, :fat, :ff,
      :fi, :fil, :fit, :fj, :fo, :fon, :fr, :frc, :frm, :fro,
      :frp, :frr, :frs, :fur, :fy, :ga, :gaa, :gag, :gan, :gay,
      :gba, :gbz, :gd, :gez, :gil, :gl, :glk, :gmh, :gn, :goh,
      :gom, :gon, :gor, :got, :grb, :grc, :gsw, :gu, :guc, :gur,
      :guz, :gv, :gwi, :ha, :hai, :hak, :haw, :he, :hi, :hif,
      :hil, :hit, :hmn, :ho, :hr, :hsb, :hsn, :ht, :hu, :hup,
      :hy, :hz, :ia, :iba, :ibb, :id, :ie, :ig, :ii, :ik, :ilo,
      :inh, :io, :is, :it, :iu, :izh, :ja, :jam, :jbo, :jgo,
      :jmc, :jpr, :jrb, :jut, :jv, :ka, :kaa, :kab, :kac,
      :kaj, :kam, :kaw, :kbd, :kbl, :kcg, :kde, :kea, :ken,
      :kfo, :kg, :kgp, :kha, :kho, :khq, :khw, :ki, :kiu, :kj,
      :kk, :kkj, :kl, :kln, :km, :kmb, :kn, :ko, :koi, :kok,
      :kos, :kpe, :kr, :krc, :kri, :krj, :krl, :kru, :ks, :ksb,
      :ksf, :ksh, :ku, :kum, :kut, :kv, :kw, :ky, :la, :lad,
      :lag, :lah, :lam, :lb, :lez, :lfn, :lg, :li, :lij, :liv,
      :lkt, :lmo, :ln, :lo, :lol, :lou, :loz, :lrc, :lt, :ltg,
      :lu, :lua, :lui, :lun, :luo, :lus, :luy, :lv, :lzh, :lzz,
      :mad, :maf, :mag, :mai, :mak, :man, :mas, :mde, :mdf, :mdr,
      :men, :mer, :mfe, :mg, :mga, :mgh, :mgo, :mh, :mi, :mic,
      :min, :mk, :ml, :mn, :mnc, :mni, :moh, :mos, :mr, :mrj, :ms,
      :mt, :mua, :mul, :mus, :mwl, :mwr, :mwv, :my, :mye, :myv,
      :mzn, :na, :nan, :nap, :naq, :nb, :nd, :nds, :"nds-NL", :ne,
      :new, :ng, :nia, :niu, :njo, :nl, :"nl-BE", :nmg, :nn, :nnh,
      :no, :nog, :non, :nov, :nqo, :nr, :nso, :nus, :nv, :nwc, :ny,
      :nym, :nyn, :nyo, :nzi, :oc, :oj, :om, :or, :os, :osa, :ota,
      :pa, :pag, :pal, :pam, :pap, :pau, :pcd, :pcm, :pdc, :pdt,
      :peo, :pfl, :phn, :pi, :pl, :pms, :pnt, :pon, :prg, :pro,
      :ps, :pt, :qu, :quc, :qug, :raj, :rap, :rar, :rgn, :rif, :rm,
      :rn, :ro, :"ro-MD", :rof, :rom, :root, :rtm, :ru, :rue, :rug,
      :rup, :rw, :rwk, :sa, :sad, :sah, :sam, :saq, :sas, :sat, :saz,
      :sba, :sbp, :sc, :scn, :sco, :sd, :sdc, :sdh, :se, :see, :seh,
      :sei, :sel, :ses, :sg, :sga, :sgs, :sh, :shi, :shn, :shu, :si,
      :sid, :sk, :sl, :sli, :sly, :sm, :sma, :smj, :smn, :sms, :sn,
      :snk, :so, :sog, :sq, :sr, :srn, :srr, :ss, :ssy, :st, :stq,
      :su, :suk, :sus, :sux, :sv, :sw, :"sw-CD", :swb, :syc, :syr,
      :szl, :ta, :tcy, :te, :tem, :teo, :ter, :tet, :tg, :th, :ti,
      :tig, :tiv, :tk, :tkl, :tkr, :tl, :tlh, :tli, :tly, :tmh,
      :tn, :to, :tog, :tpi, :tr, :tru, :trv, :ts, :tsd, :tsi, :tt,
      :ttt, :tum, :tvl, :tw, :twq, :ty, :tyv, :tzm, :udm, :ug, :uga,
      :uk, :umb, :und, :ur, :uz, :vai, :ve, :vec, :vep, :vi, :vls,
      :vmf, :vo, :vot, :vro, :vun, :wa, :wae, :wal, :war, :was,
      :wbp, :wo, :wuu, :xal, :xh, :xmf, :xog, :yao, :yap, :yav,
      :ybb, :yi, :yo, :yrl, :yue, :za, :zap, :zbl, :zea, :zen,
      :zgh, :zh, :"zh-Hans", :"zh-Hant", :zu, :zun, :zxx, :zza]

    languages = Cldr::Export::Data::Languages.new("de")[:languages]

    assert_empty codes - languages.keys, "Unexpected missing languages"
    assert_empty languages.keys - codes, "Unexpected extra languages"
    assert_equal("Deutsch", languages[:de])
  end

  test "languages does not overwrite long form with the short one" do
    languages = Cldr::Export::Data::Languages.new(:en)[:languages]

    assert_equal "American English", languages[:"en-US"]
  end

  # Cldr::Export::Data.locales.each do |locale|
  #   test "extract languages for #{locale}" do
  #     assert_nothing_raised do
  #       Cldr::Export::Data::Languages.new(locale)
  #     end
  #   end
  # end
end

