class Controller
  attr_accessor :model, :view, :application, :history
  def initialize
    name = self.class.to_s.gsub('Controller', '')
    @model = Factory::get(name+'Model')
    @view = Factory::get(name+'View')
    @application =  Factory::get('Application')
    @history =  Factory::get('HistoryModel')
  end
end

class CategoryController < Controller
  def browse category = nil
      categories = @model.categories
      if categories
        @view.display_list(categories)
        @application.input_to 'Category', 'browse'
      else
        puts @history.category_choices.inspect
        @application.dispatch('Command', 'browse', @model.last_category)
      end
  end
end

class CommandController < Controller
  def browse category
    @model.category = category
    @view.display_list(@model.commands)
    @application.input_to 'Command', 'read'
  end

  def read choice
    command = @model.command(choice.to_i-1)
    @application.dispatch('Param', 'read')
    @application.input_to('Param', 'add')
  end

  def edit
    params = Factory::get('ParamModel')
    command = @model.command[1][1]
    params.substituted_params.each do |param|
      param_description, param_value, input = param
      if input.empty? and param_description.include? "("
        input = param_description[/\((.*?)\)/, 1]
      end
      command.gsub!(param_value, input)
    end
    Clipboard.copy command
    exit
  end
end

class ParamController < Controller
  def read
    if param = @model.params_pop
      puts param.inspect
      @view.display_item param.keys.to_s
    else
      @application.dispatch('Command', 'edit')
    end
  end

  def add input
    @model.substituted_params.push(@model.param.to_a.flatten.push(input))
    @application.dispatch('Param', 'read')
  end
end

