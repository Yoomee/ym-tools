module YmTools::Command
  class Update < Base
    def index
      puts "Updating project and all local gems..."
      str = IO.popen("git pull origin master").readlines.to_s
      Dir["vendor/gems/**"].each do |gem_path|
        str += IO.popen("cd #{gem_path} && git pull origin master").readlines.to_s
      end
      repos = str.split(/updating/)
      updated_repos = repos.reject{|repo| repo.match(/Already up-to-date/)}.join("updating")
      puts updated_repos.empty? ? "Everything is already up-to-date." : updated_repos
      migrations = str.scan(/\w*\/?migrate[^\s]*/).uniq
      if !migrations.empty?
        puts "\n\nAdded #{migrations.size} migration#{'s' if migrations.size > 1}:\n + #{migrations.join("\n + ")}"
        system("rake db:migrate") if confirm("Run rake db:migrate now? (y/n)")
      end
    end
  end
end