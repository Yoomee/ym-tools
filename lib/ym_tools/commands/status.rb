module YmTools::Command
  class Status < Base
    def index
      @clean = []
      puts_status("root",IO.popen("git status").read)
      Dir["vendor/gems/**"].each do |gem_path|
        puts_status(gem_path,IO.popen("cd #{gem_path} && git status").read)
      end
      puts "clean: #{@clean.join(', ')}"
    end
    
    private
    def puts_status(dir,status)
      if !(status =~ /ahead/m) && status =~ /working directory clean/m
        @clean << dir.sub(/vendor\/gems\//,'')
      else
        puts dir unless dir == "root"
        puts status
        puts "\n"
      end
    end
  end
end
