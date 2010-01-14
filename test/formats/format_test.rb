# # encoding: utf-8
# require File.dirname(__FILE__) + '/../test_helper'
# 
# class TestCldrFormat < Test::Unit::TestCase
#   def setup
#     @locale  = :de
#     @symbols = { :decimal => ",", :group => ".", :percent_sign => "%" }
#   end
# 
#   def format_number(number, options = {})
#     options = @symbols.merge(:format => "#,##0.###").merge(options)
#     Cldr::Format.format_number(number, options)
#   end
# 
#   def format_currency(number, options = {})
#     options = @symbols.merge(:format => "#,##0.00 ¤", :currency => 'EUR').merge(options)
#     Cldr::Format.format_currency(number, options)
#   end
# 
#   def format_percent(number, options = {})
#     options = @symbols.merge(:format => "#,##0.## %").merge(options)
#     Cldr::Format.format_percent(number, options)
#   end
# 
#   # format_number
# 
#   define_method :"test: format_number applies a fraction to an integer (as defined by the format)" do
#     assert_equal '1.000,0', format_number(1000)
#   end
# 
#   define_method :"test: format_number applies a fraction to a float (as defined by the format)" do
#     assert_equal '1.000,0', format_number(1000.0)
#   end
# 
#   define_method :"test: format_currency applies a fraction to an integer (as defined by the format)" do
#     assert_equal '1.000,00 EUR', format_currency(1000)
#   end
# 
#   define_method :"test: format_currency applies a fraction to a float (as defined by the format)" do
#     assert_equal '1.000,00 EUR', format_currency(1000.0)
#   end
# 
#   define_method :"test: format_percent applies a fraction to an integer (as defined by the format)" do
#     assert_equal '1.000,0 %', format_percent(1000)
#   end
# 
#   define_method :"test: format_percent applies a fraction to a float (as defined by the format)" do
#     assert_equal '1.000,0 %', format_percent(1000.0)
#   end
# 
#   # format_number :as => :integer
# 
#   define_method :"test: format_number applies a fraction to an integer (:as => [:int|:integer])" do
#     assert_equal '1.000', format_number(1000, :as => :int)
#   end
# 
#   define_method :"test: format_number applies a fraction to a float (:as => :integer)" do
#     assert_equal '1.000', format_number(1000.0, :as => :int)
#   end
# 
#   define_method :"test: format_currency applies a fraction to an integer (:as => :integer)" do
#     assert_equal '1.000 EUR', format_currency(1000, :as => :int)
#   end
# 
#   define_method :"test: format_currency applies a fraction to a float (:as => :integer)" do
#     assert_equal '1.000 EUR', format_currency(1000.0, :as => :integer)
#   end
# 
#   define_method :"test: format_percent applies a fraction to an integer (:as => :integer)" do
#     assert_equal '1.000 %', format_percent(1000, :as => :integer)
#   end
# 
#   define_method :"test: format_percent applies a fraction to a float (:as => :integer)" do
#     assert_equal '1.000 %', format_percent(1000.0, :as => :integer)
#   end
# end