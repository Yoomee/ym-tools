module YmTools::Command
  class Gem < Base
    def reinstall(path="~/Rails/Gems/ym_tools")
      if sudo?
        display("Installing gem from #{path}") if path == "~/Rails/Gems/ym_tools"
        display("- generating gemspec...",false) 
        display("complete.") if %x{cd #{path}; rake gemspecs}
        display("- building gem.........",false) 
        display("complete.") if res = %x{cd #{path}; gem build ym_tools.gemspec}
        display("- installing gem.......",false) 
        display("complete.") if res = %x{cd #{path}; gem install ym_tools*.gem}
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
          display("complete.") if git("clone", "gems/ym_tools", "./ym_tools_gem_temp")
          reinstall(File.join(Dir.pwd,"ym_tools_gem_temp"))
          %x{rm -rf ./ym_tools_gem_temp}
        else
          display("FAILED: Root privileges are required to install gems, please run again with sudo.") 
        end
      end
    end
    
    def bump
      gem_name = Dir["*.gemspec"][0].split(/\./).first
      gem_name_camelcase = camelize(gem_name)
      
      current_version = constantize("#{gem_name_camelcase}::VERSION")
      major,minor,patch = current_version.split(/\./).collect(&:to_i)
      if patch
        patch += 1
      elsif minor
        minor += 1
      else
        major += 1
      end
      new_version = [major, minor, patch].compact.join('.')
      
      display("===========================================")      
      display(" Current version................... #{current_version}")
      display(" New version...............[#{new_version}] ",false)
      ask_for_version = ask
      new_version = ask_for_version unless ask_for_version.strip == ""
      display("===========================================")      
      
      # Write new version to lib/*/version.rb
      display(" Writing to version.rb................",false)
      version_file_path = File.join("lib", gem_name, "version.rb")
      absolute_version_file_path = File.join(Dir.pwd,version_file_path)
      version_file = File.read(absolute_version_file_path).gsub!(current_version,new_version)
      File.open(absolute_version_file_path, 'w'){|f| f.puts version_file} unless dry_run?
      display('DONE')      
      
      display(" Commiting and pushing version.rb.....",false)
      shell("git add #{version_file_path}")
      shell("git commit -m 'Bump version to #{new_version}' -- #{version_file_path}")
      shell("git push")
      display('DONE')
      
      display(" Removing old packages in ............",false)
      shell("rm -rf ./pkg")
      display('DONE')   

      display(" Building gem.........................",false)
      shell("bundle exec rake build")
      display('DONE')
      
      display(" Pushing to gem server................",false)
      shell("gem inabox pkg/#{gem_name}-#{new_version}.gem")
      display('DONE')
      
      display(" Adding git tag v#{new_version}...............",false)
      shell("git tag v#{new_version}")
      display('DONE')
      
      display(" Pushing tags.........................",false)
      shell("git push --tags")
      display('DONE')
      
      display("===========================================")      
    end
    
    def edit
      if gem_name = args[0]
        path = File.expand_path("~/Rails/Gems/#{gem_name}")
        if File.directory?(path)
          display(" Pulling #{gem_name}.git..............",false)
          shell("cd #{path} && git pull")
        else
          display(" Cloning #{gem_name}.git..............",false)
          shell("git clone git@gitlab.yoomee.com:#{gem_name}.git #{path}")
        end
        display('DONE')
        shell("#{ENV['EDITOR']} #{path}")
      else
        puts "e.g. ym gem:edit ym_core"
      end
    end
    
    private
    def camelize(before_camelize)
      string = before_camelize.dup
      string.gsub!(/_/, ' ')
      string.gsub!(/^[a-z]|\s+[a-z]/) { |a| a.upcase }
      string.gsub!(/\s/, '')
    end
    
    def constantize(camel_cased_word)
      names = camel_cased_word.split('::')
      names.shift if names.empty? || names.first.empty?

      constant = Object
      names.each do |name|
        constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
      end
      constant
    end
    
  end
end