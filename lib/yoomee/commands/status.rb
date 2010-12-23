module Yoomee::Command
  class Status < Base
    def index
      puts "Getting status of project and all subprojects..."
      str = IO.popen("ext status").readlines.to_s
      repos = str.split("\n\n")
      changed_repos = repos.reject{|repo| repo.match(/^status for.*nothing to commit \(working directory clean\)$/m)}.join("\n\n")
      puts changed_repos.empty? ? "Nothing to commit, all working directories clean." : changed_repos
    end
  end
end