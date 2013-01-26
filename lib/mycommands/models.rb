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

class CategoryModel
  include Observable
  attr_reader :categories, :category, :count, :choices
  def initialize
    add_observer Factory::get(:CommandModel)
    default_yml = Path+'/mycommands/categories.yml'
    user_yml = ENV['HOME']+'/Mycommands/categories.yml'
    yml = File.exist?(user_yml) ? user_yml : default_yml
    @all_categories = YAML::load(File.open(yml))
    @choices = []
    @category = ''
    set_categories
  end

  def choose choice
    @choices.push choice.to_i - 1
    set_categories
  end

  def go_back
    @choices.pop
    set_categories
  end

  def set_categories
    @categories = @all_categories
    for choice in @choices
      @categories = @categories.sort[choice][1]
    end
    if @categories
      @categories = @categories.sort.map {|i| i = i[0]}
      @count = @categories.size
      @categories
    else
      @count = 0
      nil
    end
    set_category
  end

  def set_category
    unless @choices.empty?
      categories = @all_categories.clone
      choices = @choices.clone
      last_choice = choices.pop
      if choices.empty?
        @category = categories.sort[last_choice][0]
      else
        for choice in choices
          categories = categories.sort[choice][1]
        end
        @category = categories.sort[last_choice][0]
      end
      @category
    else
      @category = nil
    end
    changed
    notify_observers self
  end
end

class CommandModel
  include Observable
  attr_reader :commands, :command, :category, :offset, :finished_command
  def initialize
    add_observer Factory::get(:ParamModel)
    default_yml = Path+'/mycommands/commands.yml'
    user_yml = ENV['HOME']+'/Mycommands/commands.yml'
    yml = File.exist?(user_yml) ? user_yml : default_yml
    @all_commands = YAML::load(File.open(yml))
    @offset = 0
  end

  def update category
    unless category.category.nil?
      @category = category.category
      @offset = 0 #category.count
      @commands = @all_commands.to_a.select {|c| c[1][0] == category.category}
    else
      @commands = nil
      @offset = 0
      @category = nil
    end
  end

  def choose choice
    require 'pry'; binding.pry
    set_command choice.to_i - 1 - @offset
  end

  def set_command choice
    @command = @commands[choice]
    require 'pry'; binding.pry
    changed
    notify_observers self
  end

  def command_string
    @command[1][1]
  end

  def command_params
    @command[1][2..-1].reverse
  end

  def substitute_params
    @finished_command = command_string
    Factory::get('ParamModel').substituted_params.each do |param|
      @finished_command = @finished_command.gsub param.keys.first.to_s, param.values.first.to_s
    end
  end
end

class ParamModel
  attr_accessor :substituted_params
  attr_reader :params, :param, :current_param
  def initialize
    @substituted_params = []
    @current_param = 0
  end

  def update command
    @params = command.command_params
  end

  def param
    @params.reverse[@current_param]
  end

  def param_description
    param.values.flatten.first.to_s
  end
  
  def param_value
    param.keys.first.to_s
  end

  def substitute_param input
    if input.empty? and param_description.include? "("
      input = param_description[/\((.*?)\)/, 1]
    end
    @substituted_params.push param_value => input
    result = [param_value, input]
    @current_param = @current_param + 1
    return result
  end
end