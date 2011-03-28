#    Copyright (C) 2011 Nils Eriksson
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

class Controller
  attr_accessor :model, :view, :application, :history
  def initialize
    name = self.class.to_s.gsub('Controller', '')
    @model = Factory::get(name+'Model')
    @view = Factory::get(name+'View')
    @application =  Factory::get(:Application)
    @history =  Factory::get(:HistoryModel)
  end
end

class CategoryController < Controller
  def browse choice = nil
    if !Factory::get(:HistoryModel).at_start? and @model.count < choice.to_i
      Factory::get(:ParamController).read choice.to_i-@model.count
      return
    end
    categories = @model.categories
    category = @model.last_category
    if categories
      @view.display_list(categories, category)
      Factory::get(:CommandController).browse(category, @model.count) unless Factory::get(:HistoryModel).at_start?
      @application.input_to 'Category', 'browse'
    else
      @application.dispatch('Command', 'browse', category)
    end
  end
end

class CommandController < Controller
  def browse category, offset = 0
    only_commands = offset == 0
    @model.category = category
    commands = @model.commands
    if commands.empty? and only_commands
      @view.empty_category category
      exit
    elsif !commands.empty?
      @view.display_list(commands, category, offset)
      @application.input_to 'Param', 'read' if only_commands
    end
  end

  def edit
    params = Factory::get('ParamModel')
    command = @model.command_string
    params.substituted_params.each do |param|
      param_description, param_value, input = param
      if input.empty? and param_description.include? "("
        input = param_description[/\((.*?)\)/, 1]
      end
      command.gsub!(param_value, input)
    end
    @view.display_item command
    Clipboard.copy command
    exit
  end
end

class ParamController < Controller
  def read choice = nil
    unless choice.nil?
      Factory::get(:CommandModel).set_command(choice.to_i-1)
      @model.set_params
    end
    if param = @model.params_pop
      @view.display_item param.keys.to_s
      @application.input_to('Param', 'edit')
    else
      @application.dispatch('Command', 'edit')
    end
  end

  def edit input
    @model.substituted_params.push(@model.param.to_a.flatten.push(input))
    @application.dispatch('Param', 'read')
  end
end

