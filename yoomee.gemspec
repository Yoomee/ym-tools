$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "yoomee/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "yoomee"
  s.version     = Yoomee::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Yoomee."
  s.executables = ["ym", "yoomee"]
  s.description = "TODO: Description of Yoomee."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.0"
  s.add_dependency "git", "~> 1.2.5"
  s.add_dependency "net-ssh"
  s.add_dependency "engineyard", "~> 1.4.22"
  s.add_development_dependency "sqlite3"
  
end
