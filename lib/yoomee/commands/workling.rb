module Yoomee::Command
  class Workling < Base
    
    def start
      environment = args[0] || "development"
      if !in_project_root?
        display("FAILED, make sure you are in the root directory of a project.")
      elsif sudo?
        # TODO: check if starling is already running
        if starling_running?
          display("Starling is already running.")            
        else
          display("Starting starling...")
          starling_port = environment=="production" ? "15151" : "22122"
          shell("starling -d -p #{starling_port}")
        end
        shell("export RAILS_ENV=production") if environment=="production"
        shell("script/workling_client start")
      else
        display("FAILED: Root privileges are required to install gems, please run again with sudo.") 
      end
    end
    
    def stop
      environment = args[0] || "development"
      # TODO: could stop starling as well if we could find it's pid
      if environment == "production"
        shell("export RAILS_ENV=production")
        shell("script/workling_client stop")          
      elsif environment == "development"
        shell("script/workling_client stop")
      end
    end
    
    private
    def starling_running?
      ret = %x{ps -ef|grep starling}
      ret.match(/starling -d -p 22122/)
    end
    
  end
end