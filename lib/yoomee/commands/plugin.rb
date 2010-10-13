module Yoomee::Command
  class Plugin < Base
    
    def install
      plugin_name = args[0]
      plugin_name = "tramlines_#{plugin_name}" unless plugin_name.match(/^tramlines_/)
      if !Dir.pwd.match(/Rails\/[^\/]+$/)
        display("FAILED, make sure you are in the root directory of a project.")
      elsif confirm("Install #{plugin_name}? (y/n)")
        if File.exists?(File.join(Dir.pwd, "vendor/plugins/#{plugin_name}"))
          display("FAILED, vendor/plugins/#{plugin_name} already exists.")
        else
          display("Installing......", true)
          if shell("ext install " + yoomee_git_path("plugins/#{plugin_name}") + " vendor/plugins/#{plugin_name}")
            display("Successfully installed #{plugin_name}.")
          else
            display("FAILED, see error message above.")
          end
        end        
      end
    end
   
    def uninstall
      plugin_name = args[0]
      plugin_name = "tramlines_#{plugin_name}" unless plugin_name.match(/^tramlines_/)
      if !Dir.pwd.match(/Rails\/[^\/]+$/)
        display("FAILED, make sure you are in the root directory of a project.")
      elsif confirm("Uninstall #{plugin_name}? (y/n)")
        if !File.exists?(File.join(Dir.pwd, "vendor/plugins/#{plugin_name}"))
          display("FAILED, could not find vendor/plugins/#{plugin_name}.")
        else
          display("Uninstalling......", true)
          if shell("ext uninstall vendor/plugins/#{plugin_name}")
            if shell("rm -rf vendor/plugins/#{plugin_name}")
              display("Successfully removed #{plugin_name}.")
            else
              display("FAILED, external removed but could not delete directory vendor/plugins/#{plugin_name}")
            end
          else
            display("FAILED, see error message above.")
          end
        end        
      end
    end
    alias_method :remove, :uninstall
    
  end
end