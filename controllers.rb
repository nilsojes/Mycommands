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
  def browse choice = nil
    if choice == '0'
      @model.back
    elsif !choice.nil?
      @model.choose choice
    end
    @view.display_list(@model.categories, @model.category) if @model.categories
    Factory::get(:CommandController).browse
  end
end

class CommandController < Controller
  def browse
    @view.display_list(@model.commands, @model.category, @model.offset) if @model.commands
  end

  def read choice
    @model.choose choice
    unless @model.command_params.empty?
      @application.dispatch [:Param, :read]
      return
    end
    @view.display_item @model.command_string
    Clipboard.copy @model.command_string
    exit
  end

  def edit
    @model.substitute_params
    @view.display_item @model.finished_command
    Clipboard.copy @model.finished_command
    exit
  end
end

class ParamController < Controller
  def read
    @view.display_item @model.param_description
  end

  def edit input
    @model.substitute_param input
    if @model.current_param == @model.params.size
      @application.dispatch([:Command, :edit])
    else
      @application.dispatch([:Param, :read])
    end
  end
end

