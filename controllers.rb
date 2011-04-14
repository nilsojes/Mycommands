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
end

class CategoryController < Controller
  def index choice = nil
    if choice == '0'
      @model.go_back
    elsif !choice.nil?
      @model.choose choice
    end
    @view.index(@model.categories, @model.category) if @model.categories
    Factory::get(:CommandController).index
  end
end

class CommandController < Controller
  def index
    @view.index(@model.commands, @model.category, @model.offset) if @model.commands
  end

  def show choice
    @model.choose choice
    unless @model.command_params.empty?
      @application.dispatch [:Param, :show]
      return
    end
    @view.show @model.command_string
    Clipboard.copy @model.command_string
    exit
  end

  def update
    @model.substitute_params
    @view.show @model.finished_command
    Clipboard.copy @model.finished_command
    exit
  end
end

class ParamController < Controller
  def show
    @view.show @model.param_description
  end

  def update input
    @model.substitute_param input
    if @model.current_param == @model.params.size
      @application.dispatch([:Command, :update])
    else
      @application.dispatch([:Param, :show])
    end
  end
end

