module Yoomee::Command
  class Status < Base
    def index
      str = IO.popen("ext status").readlines.to_s
      repos = str.split("\n\n")
      changed_repos = repos.reject{|repo| repo.match(/^status for.*nothing to commit \(working directory clean\)$/m)}
      puts changed_repos.join("\n\n")
    end
  end
end