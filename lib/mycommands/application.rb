module Mycommands
  class Application
    def initialize
      @router = Factory::get(:Router)
    end

    def print_version
      puts "Mycommands #{VERSION}"
    end

    def sort_yaml_files
      dispatch ['Application', 'sort_yaml_files']
    end

    def run
      dispatch ['Category', 'index']
      get_input
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