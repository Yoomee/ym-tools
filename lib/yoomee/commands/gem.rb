module Yoomee::Command
  class Gem < Base
    def reinstall(path="~/Rails/yoomee")
      display("Installing gem from #{path}") if path == "~/Rails/yoomee"
      display("- generating gemspec...",false) 
      display("complete.") if %x{cd #{path}; rake gemspecs}
      display("- building gem.........",false) 
      display("complete.") if res = %x{cd #{path}; gem build yoomee.gemspec}
      display("- installing gem.......",false) 
      display("complete.") if res = %x{cd #{path}; sudo gem install yoomee*.gem}    
    end
    def update
      display("Updating gem from remote repository")
      display("- getting latest code..",false) 
      display("complete.") if git("clone", "gems/yoomee", "./yoomee_gem_temp")
      reinstall(File.join(Dir.pwd,"yoomee_gem_temp"))
      %x{rm -rf ./yoomee_gem_temp}
    end
  end
end