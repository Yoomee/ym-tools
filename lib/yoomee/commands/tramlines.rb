module Yoomee::Command
  class Tramlines < Base
    
    def create
      project_name = args[0]
      if project_name.nil?
        display("FAILED: please specify the project name.")
      else
        clone_path = args[1] || project_name
        if confirm("Create new tramlines app called #{project_name}#{clone_path!=project_name ? " into directory #{clone_path}" : ''}? (y/n)")
          display("Cloning tramlines vanilla......", false)
          if git("clone", "vanilla", clone_path)
            display("success.")
            display("Updating externals...")
            out_stream = IO.popen("cd #{clone_path}; ext update")
            while out = out_stream.gets
              puts "GIT: #{out}"
            end
            # TODO: change client/config/database.yml
            # TODO: rake db:create
            # TODO: rake db:migrate
            # TODO: rake db:seed
            # TODO: create git repository on dev1
            # TODO: git remote add origin <git repository path>
          else
            display("FAILED: could not clone tramlines vanilla.")
          end
        end
      end
    end
    
  end
end