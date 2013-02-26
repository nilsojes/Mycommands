module Mycommands
  class CommandModel < Model
    def commands category
      all_commands.select {|c| c.category == category}
    end

    def command category, index
      commands(category)[index.to_i]
    end

    def sort_yaml_file!
      command_hash = all_commands.inject({}) {|command_hash, c| command_hash.merge!(c.to_hash) }
      file = File.open(default_or_user_yml('commands.yml'), 'w')
      file.write(command_hash.to_yaml(line_width: -1))
      file.path
    end

    private
    def all_commands
      @all_commands ||= begin
        YAML::load(File.open(default_or_user_yml('commands.yml'))).to_a.map {|c| Command.new(c)}.sort
      end
    end
  end

  class Command
    attr_accessor :params

    def initialize command
      @command = command
    end

    def description
      @command[0]
    end

    def category
      @command[1][0]
    end

    def command_string
      @command[1][1]
    end

    def params
      return nil unless has_params?
      @params ||= Params.new(@command[1][2..-1].reverse)
    end

    def has_params?
      @has_params ||= @command[1].size > 2
    end

    def finished_command
      finished_command = command_string
      if has_params?
        @params.each do |param|
          finished_command = finished_command.gsub(param.value, param.substituted)
        end
      end
      finished_command
    end

    def to_hash
      {@command[0] => @command[1]}
    end

    def <=> other
      [self.category, self.description] <=> [other.category, other.description]
    end
  end
end