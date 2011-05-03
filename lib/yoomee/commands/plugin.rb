module Yoomee::Command
  class Plugin < Base
    
    def install
      plugin_name = args[0]
      plugin_name = "tramlines_#{plugin_name}" unless plugin_name.match(/^tramlines_/)
      if !in_project_root?
        display("FAILED, make sure you are in the root directory of a project.")
      elsif confirm("Install #{plugin_name}? (y/n)")
        if File.exists?(File.join(Dir.pwd, "vendor/plugins/#{plugin_name}"))
          display("FAILED, vendor/plugins/#{plugin_name} already exists.")
        else
          display("Installing......", true)
          ext_install_plugin(plugin_name)
        end        
      end
    end
    
    def list
      puts dev1_root_shell("ls -l /git/plugins | awk '/git$/ {print $9}'").gsub(/.git/, "").gsub(/tramlines_/, "")
    end
   
    def uninstall
      plugin_name = args[0]
      plugin_name = "tramlines_#{plugin_name}" unless plugin_name.match(/^tramlines_/)
      if !in_project_root?
        display("FAILED, make sure you are in the root directory of a project.")
      elsif confirm("Uninstall #{plugin_name}? (y/n)")
        if !File.exists?(File.join(Dir.pwd, "vendor/plugins/#{plugin_name}"))
          display("FAILED, could not find vendor/plugins/#{plugin_name}.")
        else
          display("Uninstalling......", true)
          if shell("ext uninstall vendor/plugins/#{plugin_name}")
            if shell("rm -rf vendor/plugins/#{plugin_name}")
              display("Successfully removed #{plugin_name}.")
              plugin_file = File.read("client/config/plugins.rb").gsub(/\n?Tramlines\.add_plugin\(\:#{plugin_name.gsub(/tramlines_/, '')}\)/,'')
              File.open("client/config/plugins.rb", "w") {|file| file.write(plugin_file)}
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
    
    def create
      if !in_project_root?
        display("FAILED, make sure you are in the root directory of a project.")
      else
        plugin_name = args[0]
        if plugin_name.nil?
          display("FAILED: please specify the new plugin name.")
        elsif !dev1_root_shell("ls -l /git/plugins | grep #{plugin_name}.git$").empty?
          display("FAILED: plugin with that name already exists.")
        elsif File.exists?(File.join(Dir.pwd, "vendor/plugins/#{plugin_name}"))
          display("FAILED, vendor/plugins/#{plugin_name} already exists.")
        else
          if confirm("Create new tramlines plugin called #{plugin_name}? (y/n)")
            display("Generating plugin......", false)
            if shell("script/generate plugin #{plugin_name}")
              display("success.")
              display("Creating git repo on dev1")
              puts create_git_on_dev1("plugins/#{plugin_name}")
              display("Pushing initial commit to git repo......")
              if shell("cd vendor/plugins/#{plugin_name} && git init && git remote add origin " + yoomee_git_path("plugins/#{plugin_name}") + " && git add * && git commit -m 'Initial commit' && git push origin master")
                display("success.")
                display("Installing plugin as external")
                if shell("rm -rf vendor/plugins/#{plugin_name}")
                  ext_install_plugin(plugin_name)
                else
                  display("FAILED, see error message above.")
                end
              else
                display("FAILED, see error message above.")
              end
            else
              display("FAILED, see error message above.")
            end
          end
        end
      end
    end
    
    # def create
    #
    #   ssh dev1
    #   cd /git/plugins
    #   git init --bare tramlines_forum.git
    # LOCALLY
    #   add Tramlines.add_plugin(:name) to client/plugins.rb
    #   script/generate plugin tramlines_forum
    #   cd vendor/plugins/tramlines_forum/
    #   git init
    #   git remote add origin git://git.yoomee.com:4321/plugins/tramlines_forum.git
    #   git add *
    #   git commit -m "Initial commit"
    #   git push
    #   cd ../
    #   rm -rf tramlines_forum/
    #   cd ../../
    #   ym plugin:install forum
    #   commit project for .externals and .gitignore
    #   add plugins/tramlines_forum to vendor/.gitignore and commit
    # end
   
    private
    def add_plugin_to_plugins_file(plugin_name)
     File.open("client/config/plugins.rb", "a") {|file| file.puts "\nTramlines.add_plugin(:#{plugin_name.gsub(/tramlines_/, '')})"}
    end
    
    def ext_install_plugin(plugin_name)
      if shell("ext install " + yoomee_git_path("plugins/#{plugin_name}") + " vendor/plugins/#{plugin_name}")            
        display("Successfully installed #{plugin_name}.")
        add_plugin_to_plugins_file(plugin_name)
      else
        display("FAILED, see error message above.")
      end
    end
    
  end
end