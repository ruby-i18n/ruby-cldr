# frozen_string_literal: true

class String
   def underscore
     to_s.gsub(/::/, "/").
       gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
       gsub(/([a-z\d])([A-Z])/,'\1_\2').
       tr("-", "_").
       downcase
   end
end unless String.new.respond_to?(:underscore)