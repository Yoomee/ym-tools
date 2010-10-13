module Yoomee::Command
  class Help < Base
    class HelpGroup < Array
      attr_reader :title

      def initialize(title)
        @title = title
      end

      def command(name, description)
        self << [name, description]
      end

      def space
        self << ['', '']
      end
    end

    def self.groups
      @groups ||= []
    end

    def self.group(title, &block)
      groups << begin
        group = HelpGroup.new(title)
        yield group
        group
      end
    end

    def self.create_default_groups!
      group 'General Commands' do |group|
        group.command 'help','show this usage'
        group.space
        group.command 'get','update an app'
        group.command 'update','get an app, e.g. ym get aston'
        group.space
      end
      group 'Gem Commands' do |group|
        group.command 'gem:update','install latest version of gem, requires sudo'
        group.command 'gem:update:local','install gem from ~/Rails/Gems/yoomee, requires sudo'
      end
    end

    def index
      display usage
    end

    def usage
      longest_command_length = self.class.groups.map do |group|
        group.map { |g| g.first.length }
      end.flatten.max

      self.class.groups.inject(StringIO.new) do |output, group|
        output.puts "=== %s" % group.title
        output.puts

        group.each do |command, description|
          if command.empty?
            output.puts
          else
            output.puts "%-*s # %s" % [longest_command_length, command, description]
          end
        end

        output.puts
        output
      end.string
    end
  end
end

Yoomee::Command::Help.create_default_groups!
