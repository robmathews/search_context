$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "search_context/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "search_steroids"
  s.version     = SearchContext::VERSION
  s.authors     = ["Rob Mathews"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "https://github.com/robmathews/search_steroids/master/README.md"
  s.summary     = "TODO: Summary of SearchContext."
  s.description = "maintain a table of search terms indexed by a trigram index, for use fixing spelling errors and enhancing search"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.13"
  s.add_dependency "pg", '> 0.14.1'
  s.add_development_dependency "pg", '> 0.14.1'
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "faker"
  s.add_development_dependency "generator_spec"
  s.add_development_dependency "pry"
end
