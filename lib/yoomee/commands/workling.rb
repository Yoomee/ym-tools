module Yoomee::Command
  class Workling < Base
    
    def start
      environment = args[0] || "development"
      if !in_project_root?
        display("FAILED, make sure you are in the root directory of a project.")
      elsif !sudo?
        display("FAILED: Root privileges are required to install gems, please run again with sudo.")        
      else
        starling_port = environment=="production" ? "15151" : "22122"
        if !starling_running?(starling_port)
          shell("starling -d -p #{starling_port}")
          display("Started starling on port #{starling_port}")
        end
        shell("export RAILS_ENV=production") if environment=="production"
        shell("script/workling_client start")
        display("Started workling")
      end
    end
    
    def stop
      environment = args[0] || "development"
      if !in_project_root?
        display("FAILED, make sure you are in the root directory of a project.")
      elsif !sudo?
        display("FAILED: Root privileges are required to install gems, please run again with sudo.")         
      else
        if environment == "production"
          shell("export RAILS_ENV=production")
          shell("script/workling_client stop")    
        elsif environment == "development"
          shell("script/workling_client stop")
        end
        display("Stopped workling")
        starling_port = environment=="production" ? "15151" : "22122"      
        if starling_running?(starling_port)
          shell("kill -9 #{starling_pid}")
          display("Stopped starling on port #{starling_port}")
        end
      end
    end
    
    def restart
      if !in_project_root?
        display("FAILED, make sure you are in the root directory of a project.")
      elsif !sudo?
        display("FAILED: Root privileges are required to install gems, please run again with sudo.")
      else
        stop
        start
      end
    end
    
    private
    def starling_pid
      ret = %x{cat /var/run/starling.pid}
    end
    
    def starling_running?(starling_port = "22122")
      ret = %x{ps -ef|grep starling}
      ret.match(/starling -d -p #{starling_port}/)
    end
    
  end
end