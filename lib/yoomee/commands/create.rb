require 'net/ssh'
module Yoomee::Command
  class Create < Base

    def index
      project_name = args[0]
      if project_name.nil?
        display("FAILED: please specify the project name.")
      elsif !dev1_root_shell("ls -l /git | grep #{project_name}.git$").empty?
        display("FAILED: project with that name already exists.")
      else
        clone_path = args[1] || project_name
        if confirm("Create new tramlines app called #{project_name}#{clone_path!=project_name ? " in directory #{clone_path}" : ''}? (y/n)")
          display("ENTER SITE SETTINGS")
          display(" > Site name: ", false)
          site_name = ask
          display(" > Site url, (with http://): ", false)
          site_url = ask

          display("****************\n| GETTING CODE |\n****************")

          display("Cloning tramlines vanilla......", false)
          if git("clone", "vanilla", clone_path)
            display("success.")
            
            display("Getting externals...")
            Dir.chdir(clone_path)
            shell("ext update")
            
            display("Creating git repo on dev1")
            puts create_git_on_dev1(project_name)
            
            
            display("************\n| DATABASE |\n************")
            display("Writing database.yml...", false)
            db_config = File.read("client/config/database.yml").gsub(/vanilla/,project_name)
            File.open("client/config/database.yml", "w") {|file| file.write(db_config)}
            display("complete.")
            
            display("Preparing #{project_name}_development database....")
            Db.new("","").prepare
            
            display("************\n| SETTINGS |\n************")
            
            display("Setting remote origin to #{project_name}.git...", false)
            git_config = File.read(".git/config").gsub(/vanilla/,project_name)
            File.open(".git/config", "w") {|file| file.write(git_config)}
            display("complete.")
            
            display("Writing settings.yml...", false)
            settings = "site_name: #{site_name}\nsite_url: #{site_url}\nwebthumb_key:ff1e5c1f36807f9e87868f9c01c33dbb\ndevelopment:\n  site_name: #{site_name} development\n"
            File.open("client/config/settings.yml", "w") {|file| file.write(settings)}
            display("complete.")
            
            create_git_on_dev1(project_name)
            
          else
            display("FAILED: could not clone tramlines vanilla.")
          end
        end
      end
    end

  end
end