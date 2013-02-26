module Mycommands
  class Params
    include Enumerable
    attr_reader :params, :param, :current_param_index
    def initialize params
      @current_param_index = 0
      @params = params.map {|p| Param.new(p)}
    end

    def current_param
      @params.reverse[@current_param_index]
    end

    def next_param
      @current_param_index += 1
    end

    def all_substituted?
      @current_param_index == @params.size
    end

    def each
      for p in @params do
        yield p
      end
    end
  end

  class Param
    attr_reader :substituted

    def initialize param
      @param = param
    end

    def description
      @param.values.flatten.first.to_s
    end

    def value
      @param.keys.first.to_s
    end

    def substitute input
      if input.empty? and description.include? "("
        input = description[/\((.*?)\)/, 1]
      end
      @substituted = input
    end
  end
end