module Yoomee::Command
  class Project < Base
    
    def exists
      !dev1_root_shell("ls -l /git | grep #{args[0]}.git$").empty?
    end
    
    def list
      puts dev1_root_shell("ls -l /git | awk '/git$/ {print $9}'").gsub(/.git/, "")
    end
  end
end