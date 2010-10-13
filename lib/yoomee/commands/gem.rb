module Yoomee::Command
  class Gem < Base
    def reinstall(path="~/Rails/Gems/yoomee")
      if sudo?
        display("Installing gem from #{path}") if path == "~/Rails/Gems/yoomee"
        display("- generating gemspec...",false) 
        display("complete.") if %x{cd #{path}; rake gemspecs}
        display("- building gem.........",false) 
        display("complete.") if res = %x{cd #{path}; gem build yoomee.gemspec}
        display("- installing gem.......",false) 
        display("complete.") if res = %x{cd #{path}; gem install yoomee*.gem}
      else
        display("FAILED: Root privileges are required to install gems, please run again with sudo.") 
      end 
    end
    def update
      if args[0] == "local"
        args.shift
        reinstall
      else
        if sudo?
          display("Updating gem from remote repository")
          display("- getting latest code..",false) 
          display("complete.") if git("clone", "gems/yoomee", "./yoomee_gem_temp")
          reinstall(File.join(Dir.pwd,"yoomee_gem_temp"))
          %x{rm -rf ./yoomee_gem_temp}
        else
          display("FAILED: Root privileges are required to install gems, please run again with sudo.") 
        end
      end
    end
  end
end