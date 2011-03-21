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

    if category.class == Array
      @model.choices = category
#    debugger
    elsif  category.class == String
      choice = category.to_i - 1
      @model.choices.push choice
#    elsif choice == 0
#      @model.choices.pop
    end
#    begin
      #puts 'fetching categories'
#      debugger
      categories = @model.categories
#      @history.add('Category', 'browse', @model.choices)
      @view.display_list(categories)
      @application.input_to 'Category', 'browse'
#    rescue
#      puts 'going to commands'
#      @application.dispatch('Command', 'browse', @model.choices.last)
#    end
  end
end

class CommandController < Controller
  def browse category
#    category_model = Factory::get('CategoryModel')
    @model.category = category
    @view.display_list(@model.commands)
#    puts Factory::get('HistoryModel').history.inspect
    @history.add('Command', 'browse', category)
    @application.input_to 'Command', 'read'
  end

  def read choice
    command = @model.command(choice.to_i-1)
#    puts command.inspect
    params = command[1,100]
    puts params.inspect
#    Clipboard.copy command
#    @view.display_params(params)
#    @view.display_item(command)

  end
end

