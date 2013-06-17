$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "search_terms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "search_terms"
  s.version     = SearchTerms::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of SearchTerms."
  s.description = "TODO: Description of SearchTerms."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.13"
  s.add_dependency "pg", '~> 0.14.1'
  s.add_development_dependency "rspec-rails"
end
