module Mycommands
  class Router
    def initialize
      @routes = []
      @choice = 1
    end

    def add_route route
      if route[:match].nil?
        route.merge!(:match => @choice.to_s)
        @choice += 1
      end
      @routes.push route
      return @choice - 1
    end

    def clear_routes
      @routes = []
      @choice = 1
    end

    def route input
      @routes.each do |route|
        if input.match route[:match]
          return route[:controller], route[:action], route[:input].nil? ? input : route[:input]
        end
      end
      false
    end
  end
end