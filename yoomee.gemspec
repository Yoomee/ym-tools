# Yoomee gem

Gem::Specification.new do |spec|
  spec.platform = "ruby"
  spec.name = "yoomee"
  spec.homepage = "http://yoomee.com"
  spec.version = "0.0.1"
  spec.author = "Matt Atkins"
  spec.email = "matt@yoomee.com"
  spec.summary = "The Yoomee gem."
  spec.description = "Does lots of yoomee-specific stuff"
  spec.files = ["bin", "generators", "generators/client_migration", "generators/client_controller", "generators/client_controller/templates", "lib", "lib/yoomee", "lib/yoomee/commands", "bin/ym"]
  spec.require_path = "."
  spec.has_rdoc = true
  spec.executables = ["ym"]
  spec.extra_rdoc_files = []
  spec.rdoc_options = []
  spec.add_dependency("git")
end
