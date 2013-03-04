module Mycommands
  class Application
    OPTIONS = [
      {short: 'v', verbose: 'version', route: [:Application, :print_version], input: false, description: 'Prints the version'},
      {short: 's', verbose: 'sort', route: [:Application, :sort_yaml_files], input: false, description: 'Sorts categories.yml and commands.yml alphabetically'},
      {short: 'c', verbose: 'copy', route: [:Application, :copy_yaml_files], input: false, description: 'Copies categories.yml and commands.yml to ~/Mycommands/ so that they overrides the default ones'},
      {short: 'h', verbose: 'help', route: [:Application, :help], input: false, description: 'Shows this help'}
    ]

    def initialize
      @router = Factory::get(:Router)
    end

    def run
      route, input = check_options
      dispatch route
      get_input if input
    end

    def dispatch args
      controller, action, input= args.map &:to_s
      puts "Dispatching: #{controller}, #{action}, #{input}" if DEBUG
      if input.nil?
        Factory::get(controller+'Controller').send action
      else
        Factory::get(controller+'Controller').send action, input
      end
    end

    private
    def check_options
      option = OPTIONS.select {|option| "-" + option[:short] == ARGV.first || "--" + option[:verbose] == ARGV.first}.first
      return [option[:route], option[:input]] if option
      [[:Category, :index], true]
    end

    def get_input
      while input = Readline.readline('--> ', true)
        route = @router.route input
        @router.clear_routes
        unless route
          puts "Bye!"
          exit
        end
        dispatch route
      end
    end
  end
end