class String
  def camelize
    self.gsub(/(^.{1}|[^a-z0-9])/) { $1.capitalize }
  end
end unless String.new.respond_to?(:camelize)