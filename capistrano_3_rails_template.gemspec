$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "capistrano_3_rails_template/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "capistrano-3-rails-template"
  s.version     = Capistrano3RailsTemplate::VERSION
  s.authors     = ["Matthew Nguyen"]
  s.email       = ["contact@n-studio.fr"]
  s.homepage    = "http://www.n-studio.fr"
  s.summary     = "Generate files for rails 4.1.x deployment."
  s.description = "For postgresql."
  s.license     = "MIT"

  s.files = Dir["{app,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.1.0"
  s.add_dependency "capistrano-rails"
  s.add_dependency "capistrano-bundler"
  s.add_dependency "capistrano-rbenv"
  s.add_dependency "capistrano-rails-console"
  s.add_dependency "capistrano-rbenv-vars"
  s.add_dependency "highline"
end
