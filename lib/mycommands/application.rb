# -*- encoding : utf-8 -*-
class Application
  def initialize
    @router = Factory::get(:Router)
  end

  def run
    dispatch ['Category', 'index']
    get_input
  end

  def get_input
    while input = Readline.readline('--> ', true)
      route = @router.route input
      @router.clear_routes
      require 'pry'; binding.pry
      dispatch route
    end
  end

  def dispatch args
    controller, action, input= args.map &:to_s
    puts "Dispatching: #{controller}, #{action}, #{input}" if Debug
    if input.nil?
      Factory::get(controller+'Controller').send action
    else
      Factory::get(controller+'Controller').send action, input
    end
  end
end