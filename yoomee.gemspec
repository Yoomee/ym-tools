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
  spec.files = ["bin/ym", "generators/magic_list/templates/magic_create_action.rb", "generators/magic_list/templates/controller.rb", "generators/magic_list/templates/_magic_list_item.html.haml", "generators/magic_list/templates/_magic_list.html.haml", "generators/magic_list/templates/_magic_form.html.haml", "generators/magic_list/templates/.DS_Store", "generators/magic_list/magic_list_generator.rb", "generators/magic_list/.DS_Store", "generators/insert_commands.rb", "generators/client_migration/templates/migration.rb", "generators/client_migration/client_migration_generator.rb", "generators/client_migration/.DS_Store", "generators/client_controller/templates/view.html.haml", "generators/client_controller/templates/helper_test.rb", "generators/client_controller/templates/helper.rb", "generators/client_controller/templates/functional_test.rb", "generators/client_controller/templates/controller.rb", "generators/client_controller/client_controller_generator.rb", "generators/client_controller/.DS_Store", "generators/.DS_Store", "lib/yoomee.rb", "lib/yoomee/helpers.rb", "lib/yoomee/commands/update.rb", "lib/yoomee/commands/help.rb", "lib/yoomee/commands/get.rb", "lib/yoomee/commands/gem.rb", "lib/yoomee/commands/base.rb", "lib/yoomee/command.rb", "lib/.DS_Store"]
  spec.require_path = "."
  spec.has_rdoc = true
  spec.executables = ["ym"]
  spec.extra_rdoc_files = []
  spec.rdoc_options = []
  spec.add_dependency("git")
  spec.rubyforge_project = "nowarning"
end
