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
  spec.files = ["init.rb", "bin", "generators", "generators/magic_list", "generators/magic_list/templates", "generators/client_migration", "generators/client_migration/templates", "generators/client_controller", "generators/client_controller/templates", "lib", "lib/yoomee", "lib/yoomee/commands", "rails_generators", "rails_generators/yoomee", "rails_generators/yoomee/lib", "bin/ym"]
  spec.require_path = "."
  spec.has_rdoc = true
  spec.executables = ["ym"]
  spec.extra_rdoc_files = []
  spec.rdoc_options = []
  spec.add_dependency("git")
end
