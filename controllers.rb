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
  def initialize
    name = self.class.to_s.gsub('Controller', '')
    @model = Factory::get(name+'Model')
    @view = Factory::get(name+'View')
    @application =  Factory::get(:Application)
  end

  def render action = nil
    instance_variables.each do |i|
      @view.instance_variable_set i, eval(i) unless %w(@model view application).include? i
    end
    if action
      @view.send(action)
    else
      @view.send(caller(1).first[/`.*'/][1..-2].to_sym)
    end
  end
end

class CategoryController < Controller
  def index choice = nil
    if choice == '0'
      @model.go_back
    elsif !choice.nil?
      @model.choose choice
    end
    @categories = @model.categories
    @category = @model.category
    render if @categories
    Factory::get(:CommandController).index
  end
end

class CommandController < Controller
  def index
    @commands = @model.commands
    @category = @model.category
    @offset = @model.offset
    render if @model.commands
  end

  def show choice
    @model.choose choice
    unless @model.command_params.empty?
      @application.dispatch [:Param, :show]
      return
    end
    @command = @model.command_string
    render
    Clipboard.copy @model.command_string
    exit
  end

  def update
    @model.substitute_params
    @command = @model.finished_command
    render :show
    Clipboard.copy @model.finished_command
    exit
  end
end

class ParamController < Controller
  def show
    if @model.param.values.first.is_a? Array
      @model.param.values.flatten[1..-1].each do |line|
        eval line
      end
      @param = "#{@model.param_description} (#{@result})"
    else
      @param = @model.param_description
    end
    render
  end

  def update input
    param_value, param_input = @model.substitute_param input
    instance_variable_set "@#{param_value}", param_input
    if @model.current_param == @model.params.size
      @application.dispatch([:Command, :update])
    else
      @application.dispatch([:Param, :show])
    end
  end
end

