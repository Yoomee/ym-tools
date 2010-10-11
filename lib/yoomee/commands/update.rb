module Yoomee::Command
  class Update < Base
    def index
      display("Updating...")
      out_stream = IO.popen("ext update")
      migration = false
      while out = out_stream.gets
        puts "GIT: #{out}"
        migration = true if out =~/migrate\//
      end
      shell("rake db:migrate") if migration && confirm("Migration found, run db:migrate? (y/n)")
    end
  end
end