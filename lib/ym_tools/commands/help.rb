module YmTools::Command
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
      group 'Project Commands' do |group|
        group.command 'project:get','get a project, e.g. ym project:get worldeka'
        group.command 'project:update', 'update the project in the current directory'
        group.command 'project:exists', 'check if a project exists, e.g. ym project:exists worldeka'
        group.command 'project:list', 'list all projects'
        group.space
        group.command 'plugin:list','list all Tramlines plugins'
        group.command 'plugin:install','install a Tramlines plugin'
        group.command 'plugin:uninstall','uninstall a Tramlines plugin'
        group.space
        group.command 'workling:start','start workling and starling'
        group.command 'workling:stop','stop workling and starling'
        group.command 'workling:restart','restart workling and starling'
        group.space
        group.command 'db:prepare', 'run db:create, db:migrate and db:seed'
        group.space
        group.command 'help','show this!'
      end
      group 'Gem & Bundle Commands' do |group|
        group.command 'gem:update','install latest version of gem, requires sudo'
        group.command 'gem:update:local','install gem from ~/Rails/Gems/ym_tools, requires sudo'
        group.space
        group.command 'bundle:install','install the Yoomee TextMate bundle'
        group.command 'bundle:update','update the Yoomee TextMate bundle'
        group.command 'bundle:edit','open the Yoomee bundle in TextMate'
        group.command 'bundle:reveal','open the TextMate bundles directory in Finder'
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

YmTools::Command::Help.create_default_groups!
