$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ym_tools/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ym_tools"
  s.version     = YmTools::VERSION
  s.authors     = ["Matt Atkins", "Ian Mooney", "Edward Andrews"]
  s.email       = "developers@yoomee.com"
  s.homepage    = "http://www.yoomee.com"
  s.summary     = "Summary of YmTools."
  s.executables = ["ym", "ym_tools"]
  s.description = "Description of YmTools."

  s.files = Dir["{app,bin,config,db,generators,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency "git", "~> 1.2.5"
  s.add_dependency "net-ssh", "~> 2.2.1"
  s.add_dependency "engineyard", "~> 1.4.22"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "geminabox"
  
end
