$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rawstats/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rawstats"
  s.version     = Rawstats::VERSION
  s.authors     = ["wvengen"]
  s.email       = ["dev-rawstats@willem.engen.nl"]
  s.homepage    = "https://github.com/wvengen/rawstats"
  s.summary     = "AWStats statistics for Ruby on Rails"
  s.description = "TODO: Description of Rawstats."
  s.license     = "MIT"

  s.files = Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 3.0"
  s.add_dependency "jquery-rails"
  s.add_dependency "flot-rails", "~> 0.0.6"
  s.add_dependency "jquery-tablesorter", "~> 1.12.1"

  s.add_development_dependency 'sqlite3' # to avoid error on starting dummy app
  s.add_development_dependency 'rspec-rails', '~> 2.14.0'
end
