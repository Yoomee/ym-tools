module Yoomee::Command
  class Update < Base
    def index
      puts "Updating project and all subprojects..."
      str = IO.popen("ext update").readlines.to_s
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