require 'fileutils'

module Yoomee::Command
  class Base
    include Yoomee::Helpers

    attr_accessor :args
    def initialize(args, user)
      @args = args
      @user = user
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
    
    def git(action, git_path, relative_path = ".")
      Git.clone("git://git.yoomee.com:4321/#{git_path}.git", relative_path)
    end
    
    def sudo?
      @user == "root"
    end
    
  end
end
