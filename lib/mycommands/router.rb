# -*- encoding : utf-8 -*-
class Router
  def initialize
    @routes = []
  end

  def add_route route
    @routes.push route
  end

  def clear_routes
    @routes = []
  end

  def route input
    @routes.each do |route|
      if input.match route[:match]
        return route[:controller], route[:action], route[:input].nil? ? input : route[:input]
      end
    end
    puts "Bye!"
    exit
  end
end