module Yoomee::Command
  class Get < Base
    def index
      app_name = args[0]
      clone_path = args[1] || app_name
      if confirm("Clone #{app_name} into #{clone_path}? (y/n)")
        display("Cloning......", false)
        if git("clone", app_name, clone_path)
          display("success.")
          externals_file = File.exists?(File.join(Dir.pwd, clone_path, ".externals"))
          if externals_file && confirm("Check out externals? (y/n)")
            out = IO.popen("cd #{clone_path}; ext update")
            puts out.gets while out.gets
          end
        else
          display("FAILED, see error message above.")
        end
      end
    end
  end
end