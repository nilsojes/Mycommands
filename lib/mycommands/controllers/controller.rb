module Mycommands
  class Controller
    def initialize
      @name = self.class.to_s.gsub('Controller', '')
      set_model
      @view = Factory::get(@name+'View')
      @application =  Factory::get(:Application)
    end

    def render action = nil
      instance_variables.each do |i|
        @view.instance_variable_set i, eval(i.to_s) unless %w(@model view application).include? i
      end
      if action
        @view.send(action)
      else
        @view.send(caller(1).first[/`.*'/][1..-2].to_sym)
      end
    end

    private
    def set_model
      @model = Factory::get(@name+'Model')
    end
  end
end

