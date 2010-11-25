require 'fileutils'
require 'net/ssh'

module Yoomee::Command
  class Base
    include Yoomee::Helpers

    attr_accessor :args
    def initialize(args, user)
      @args = args
      @user = user
    end

    def in_project_root?
      # !Dir.pwd.match(/Rails\/[^\/]+$/)
      %w{Rakefile app client vendor}.all? do |directory|
        File.exists?(File.join(Dir.pwd, directory))
      end
    end

    def confirm(message="Are you sure you wish to continue? (y/n)?", default=nil)
      display("#{message} ", false)
      ask.downcase == 'y'
    end

    def format_date(date)
      date = Time.parse(date) if date.is_a?(String)
      date.strftime("%Y-%m-%d %H:%M %Z")
    end

    def ask
      gets.strip
    end

    def shell(cmd)
      FileUtils.cd(Dir.pwd) {|d| return `#{cmd}`}
    end
    
    def create_git_on_dev1(repo_path)
      dev1_root_shell("/usr/local/bin/git init --bare /git/#{repo_path}.git")
    end    
    
    def git(action, git_path, relative_path = ".")
      Git.clone(yoomee_git_path(git_path), relative_path)
    end
    
    def sudo?
      @user == "root"
    end
    
    def dev1_root_shell(cmd)
      out = ""
      Net::SSH.start('git.yoomee.com', 'si', :password => "olive123", :port => 316) do |ssh|
        channel = ssh.open_channel do |channel|
          channel.request_pty do |ch, success|
            raise "Could not obtain pty (i.e. an interactive ssh session)" if !success
          end
          channel.exec("sudo #{cmd}") do |ch, success|
            channel.on_data do |ch, data|
              if data.match(/Password/)
                channel.send_data "olive123\n"
              else
                out << data
              end
            end
          end    
        end
      end
      out
    end
    
    def trash(path)
      path = path.gsub(/ /, "\\ ")
      shell("mv #{path} ~/.Trash/#{trash_name(path.split('/').last)}\ ")
    end
    
    def yoomee_git_path(path)
      "git://git.yoomee.com:4321/#{path}.git"
    end
    
    def trash_name(filename)
      split = filename.split(".")
      if split.size > 1
        extension, name = split.pop, split.join(".")
        name + Time.now.strftime("\\ %H-%M-%S.") + extension
      else
        filename + Time.now.strftime("\\ %H-%M-%S.")
      end
    end
    
  end
end
