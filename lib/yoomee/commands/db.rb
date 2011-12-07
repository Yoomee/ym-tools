require 'engineyard/cli'
module Yoomee::Command
  class Db < Base
    def prepare
      display("Creating database......",false)
      display("complete.") if %x{rake db:create}
      display("Migrating database.....")
      %x{rake db:migrate}
      display("Seeding database.......",false)
      display("complete.") if %x{rake db:seed}
    end
    
    def fetch
      parse_args!
      
      cli = EY::CLI.new
      display("=> Fetching app details from EngineYard")
      app,environment = cli.send(:fetch_app_and_environment, @app_name, @env_name)
      
      display("=> Running rake db:dump on the server")
      hosts = cli.ssh_hosts({}, environment)
      raise NoCommandError.new if hosts.size != 1
      system Escape.shell_command(['ssh', "#{environment.username}@#{hosts.first}", "cd /data/#{app.name}/current && rake db:dump --trace RAILS_ENV=production"].compact)
      
      config = YAML.load(File.new('./config/database.yml'))["development"]
      db_name = config["database"]
      db_user = config["username"]
      
      display("=> Downloading database dump")
      system("scp #{environment.username}@#{hosts.first}:/data/#{app.name}/current/db/#{app.name}.sql.tgz ./db/#{db_name}.sql.tgz")
      
      if File.exists?("./db/#{db_name}.sql.tgz")
        display("=> Uncompressing database dump")
        system("cd ./db && tar -xzvf #{db_name}.sql.tgz && mv #{app.name}.sql #{db_name}.sql")
      else
        display("=> Compressed database dump not found, downloading uncompressed version")
        system("scp #{environment.username}@#{hosts.first}:/data/#{app.name}/current/db/#{app.name}.sql ./db/#{db_name}.sql")
      end
      
      display("=> Dropping local database")
      system("rake db:drop")
      
      display("=> Creating local database")
      system("rake db:create")
      
      display("=> Importing database")
      system("mysql -u#{db_user} #{db_name} < ./db/#{db_name}.sql")
      
      display("COMPLETE")
    end
    
    def parse_args!
      if args.detect {|arg| arg.match(/^(--app|-?a)='?([^\s']+)'?/)}
        @app_name = $2
      end
      if args.detect {|arg| arg.match(/^(--environment|-?e)='?([^\s']+)'?/)}
        @env_name = $2
      end
    end
    
  end
end