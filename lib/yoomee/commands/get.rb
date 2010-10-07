module Yoomee::Command
  class Get < Base
    def index
      app_name = args[0]
      clone_path = args[1] || app_name
      puts "Cloning #{app_name} into #{clone_path}..."
      shell("git clone git://git.yoomee.com:4321/#{app_name}.git #{clone_path}")
      puts "Checking out externals..."
      %x{cd #{clone_path}; ext update}
    end
  end
end