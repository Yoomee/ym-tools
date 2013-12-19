require 'engineyard/cli'
module YmTools::Command
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
      system Escape.shell_command(['ssh', "#{environment.username}@#{hosts.first}", "cd /data/#{app.name}/current && $(which bundle) exec rake db:dump --trace RAILS_ENV=production"].compact)
      
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
      app_next = env_next = false
      args.each do |arg|
        if app_next
          @app_name = arg.strip
          app_next = false
        elsif env_next
          @env_name = arg.strip
          app_next = false
        elsif arg.strip =~ /(--app|-a)/
          app_next = true
        elsif arg.strip =~ /(--environment|-e)/
          env_next = true
        end
      end
    end
    
  end
end