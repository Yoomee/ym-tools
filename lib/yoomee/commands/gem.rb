module Yoomee::Command
  class Gem < Base
    def reinstall
      puts "Rebuilding and installing gem from ~/Rails/yoomee"
      res = %x{cd ~/Rails/Gems/yoomee; rake gemspecs; gem build yoomee.gemspec; sudo gem install yoomee*.gem}
      puts "Complete."
    end
  end
end