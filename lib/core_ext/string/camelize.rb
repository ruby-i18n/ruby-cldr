class String
  def camelize
    self.gsub(/(^.|_[a-zA-Z])/) { |m| m.sub("_",'').capitalize }
  end
end unless String.new.respond_to?(:camelize)