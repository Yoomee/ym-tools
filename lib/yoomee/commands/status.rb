module Yoomee::Command
  class Status < Base
    def index
      puts "Getting status of project and all local gems..."
      statuses = [[
        "root",
        IO.popen("git status").read
      ]]
      Dir["vendor/gems/**"].each do |gem_path|
        statuses << [gem_path, IO.popen("cd #{gem_path} && git status").read]
      end
      statuses.each do |status|
        puts status[0] unless status[0] == "root"
        puts status[1].to_s
        puts "\n"
      end
    end
  end
end