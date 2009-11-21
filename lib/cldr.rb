require 'rubygems'
require 'hpricot'

module Cldr
  autoload :Plural, 'cldr/plural'
end

# class Rules < Array
#   attr_reader :locales
#
#   def initialize(locales)
#     @locales = locales
#   end
#
#   def <<(args)
#     category, code = args
#     super([category, translate(code)])
#   end
#
#   def translate(code)
#     map = { 'is' => '==', 'is not' => '!=', 'mod' => '%' }
#     code.gsub!(/(mod|is not|is)/) { map[$1] }
#     code.gsub!(/(n.*) not in ([\d\.]+)/u) { "!(#{$2}).include?(#{$1})" }
#     # code.gsub!(/(n.*) in ([\d\.]+)/) { "(#{$2}).include?(#{$1})" }
#     code
#   end
# end
#
# # doc = Hpricot.XML(open(File.dirname(__FILE__) + "/../vendor/cldr/data/core/supplemental/plurals.xml"))
# # rules = (doc / :pluralRules).map do |set|
# #   rules = Rules.new(set.attributes['locales'].split(/\s+/))
# #   rules = (set / :pluralRule).inject(rules) { |rules, r| rules << [r.attributes['count'], r.inner_html] }
# # end
# # p rules