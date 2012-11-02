# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ya2yaml"
  s.version = "0.30"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Akira FUNAI"]
  s.cert_chain = nil
  s.date = "2010-08-27"
  s.description = "Ya2YAML is \"yet another to_yaml\". It emits YAML document with complete UTF8 support (string/binary detection, \"\\u\" escape sequences and Unicode specific line breaks).\n"
  s.email = "akira@funai.com"
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc"]
  s.homepage = "http://rubyforge.org/projects/ya2yaml/"
  s.rdoc_options = ["--main", "README.rdoc", "--charset", "UTF8"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubyforge_project = "ya2yaml"
  s.rubygems_version = "1.8.24"
  s.summary = "An UTF8 safe YAML dumper."

  if s.respond_to? :specification_version then
    s.specification_version = 1

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
