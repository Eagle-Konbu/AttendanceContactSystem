# -*- encoding: utf-8 -*-
# stub: wareki 1.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "wareki".freeze
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Tatsuki Sugiura".freeze]
  s.date = "2019-12-23"
  s.description = "Pure ruby library of Wareki (Japanese calendar date) that supports string parsing,\nformatting, and bi-directional convertion with standard Date class.\n".freeze
  s.email = ["sugi@nemui.org".freeze]
  s.homepage = "https://github.com/sugi/wareki".freeze
  s.licenses = ["BSD".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0".freeze)
  s.rubygems_version = "2.7.6.2".freeze
  s.summary = "Pure ruby library of Wareki (Japanese calendar date)".freeze

  s.installed_by_version = "2.7.6.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ya_kansuji>.freeze, ["< 2.0.0", "> 0.0.9"])
      s.add_development_dependency(%q<bundler>.freeze, [">= 1.9"])
      s.add_development_dependency(%q<rake>.freeze, [">= 10.0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
    else
      s.add_dependency(%q<ya_kansuji>.freeze, ["< 2.0.0", "> 0.0.9"])
      s.add_dependency(%q<bundler>.freeze, [">= 1.9"])
      s.add_dependency(%q<rake>.freeze, [">= 10.0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<ya_kansuji>.freeze, ["< 2.0.0", "> 0.0.9"])
    s.add_dependency(%q<bundler>.freeze, [">= 1.9"])
    s.add_dependency(%q<rake>.freeze, [">= 10.0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
  end
end
