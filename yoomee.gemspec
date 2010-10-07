# Yoomee gem

Gem::Specification.new do |spec|
  spec.platform = "ruby"
  spec.name = "yoomee"
  spec.homepage = "http://yoomee.com"
  spec.version = "0.0.1"
  spec.author = "Matt Atkins"
  spec.email = "matt@yoomee.com"
  spec.summary = "The Yoomee gem."
  spec.files = ["bin/ym", "generators/client_migration/client_migration_generator.rb", "generators/client_controller/templates/view.html.haml", "generators/client_controller/templates/helper_test.rb", "generators/client_controller/templates/helper.rb", "generators/client_controller/templates/functional_test.rb", "generators/client_controller/templates/controller.rb", "generators/client_controller/client_controller_generator.rb", "lib/yoomee.rb", "lib/yoomee/commands/help.rb", "lib/yoomee/commands/get.rb", "lib/yoomee/commands/base.rb", "lib/yoomee/command.rb", "lib/yoomee/.DS_Store"]
  spec.require_path = "."
  spec.has_rdoc = true
  spec.executables = ["ym"]
  spec.extra_rdoc_files = []
  spec.rdoc_options = []
end
