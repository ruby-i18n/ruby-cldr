# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "jeweler"
  s.version = "1.6.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Josh Nichols"]
  s.date = "2011-07-06"
  s.description = "Simple and opinionated helper for creating Rubygem projects on GitHub"
  s.email = "josh@technicalpickles.com"
  s.executables = ["jeweler"]
  s.extra_rdoc_files = ["ChangeLog.markdown", "LICENSE.txt", "README.markdown"]
  s.files = ["bin/jeweler", "ChangeLog.markdown", "LICENSE.txt", "README.markdown"]
  s.homepage = "http://github.com/technicalpickles/jeweler"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Opinionated tool for creating and managing RubyGem projects"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 0"])
      s.add_runtime_dependency(%q<git>, [">= 1.2.5"])
      s.add_runtime_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<mhennemeyer-output_catcher>, [">= 0"])
      s.add_development_dependency(%q<rr>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<redgreen>, [">= 0"])
      s.add_development_dependency(%q<test-construct>, [">= 0"])
      s.add_development_dependency(%q<yard>, ["~> 0.6.0"])
      s.add_development_dependency(%q<bluecloth>, [">= 0"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<timecop>, [">= 0"])
      s.add_development_dependency(%q<activesupport>, ["~> 2.3.5"])
      s.add_development_dependency(%q<ruby-debug>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<git>, [">= 1.2.5"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<mhennemeyer-output_catcher>, [">= 0"])
      s.add_dependency(%q<rr>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<redgreen>, [">= 0"])
      s.add_dependency(%q<test-construct>, [">= 0"])
      s.add_dependency(%q<yard>, ["~> 0.6.0"])
      s.add_dependency(%q<bluecloth>, [">= 0"])
      s.add_dependency(%q<cucumber>, [">= 0"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<timecop>, [">= 0"])
      s.add_dependency(%q<activesupport>, ["~> 2.3.5"])
      s.add_dependency(%q<ruby-debug>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<git>, [">= 1.2.5"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<mhennemeyer-output_catcher>, [">= 0"])
    s.add_dependency(%q<rr>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<redgreen>, [">= 0"])
    s.add_dependency(%q<test-construct>, [">= 0"])
    s.add_dependency(%q<yard>, ["~> 0.6.0"])
    s.add_dependency(%q<bluecloth>, [">= 0"])
    s.add_dependency(%q<cucumber>, [">= 0"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<timecop>, [">= 0"])
    s.add_dependency(%q<activesupport>, ["~> 2.3.5"])
    s.add_dependency(%q<ruby-debug>, [">= 0"])
  end
end
