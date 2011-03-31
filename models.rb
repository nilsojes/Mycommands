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

class HistoryModel
  attr_reader :history
  def initialize
    @history = []
  end

  def add *dispatch_args
    @history.push dispatch_args
  end

  def back
    if @history.last[0] == 'Command'
      @history.pop(2)
    else
      @history.pop
    end
  end

  def category_choices
    @history.select {|h| h[0]=='Category'}.map {|h| h=h[2]}.select{|h| !h.nil?}.map {|h| h=h.to_i-1}
  end

  def at_start?
    @history.size == 1
  end
end

class CategoryModel
  include Observable
  attr_reader :categories, :category, :count, :choices
  def initialize
    default_yml = Path+'/categories.yml'
    user_yml = ENV['HOME']+'/Mycommands/categories.yml'
    yml = File.exist?(user_yml) ? user_yml : default_yml
    @all_categories = YAML::load(File.open(yml))
    @choices = []
    @category = ''
    set_categories
    add_observer Factory::get(:CommandModel)
  end

  def choose choice
    @choices.push choice.to_i - 1
#    puts @choices.inspect
    set_categories
  end

  def back
    @choices.pop
    set_categories
  end

  def set_categories
    if @choices.empty?
      @categories = @all_categories
    else
      @categories = @all_categories
      for choice in @choices
        @categories = @categories.sort[choice][1]
      end
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
      categories = @all_categories
      choices = @choices.clone
      last_choice = choices.pop
      if choices.empty?
        @category = categories.sort[last_choice][0]
      else
        for choice in choices
          categories = categories.sort[choice][1]
        end
        @category = categories.to_a[last_choice][0]
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
  attr_reader :commands, :command, :category, :offset
  def initialize
    default_yml = Path+'/commands.yml'
    user_yml = ENV['HOME']+'/Mycommands/commands.yml'
    yml = File.exist?(user_yml) ? user_yml : default_yml
    @all_commands = YAML::load(File.open(yml))
    @offset = 0
    add_observer Factory::get(:ParamModel)
  end

  def update category
    unless category.category.nil?
      @category = category.category
      @offset = category.count
      @commands = @all_commands.to_a.select {|c| c[1][0] == category.category}
    else
      @commands = nil
      @offset = 0
      @category = nil
    end
  end

  def choose choice
    set_command choice.to_i - 1 - @offset
  end

  def set_command choice
    @command = @commands[choice]
    changed
    notify_observers self
  end

  def command_string
    @command[1][1]
  end

  def command_params
    @command[1][2..-1].reverse
  end
end

class ParamModel
  attr_accessor :substituted_params
  attr_reader :params, :param
  def initialize
    @substituted_params = []
  end

  def update command
    @params = command.command_params
  end

#  def set_params
#    @params = Factory::get(:CommandModel).command_params
#  end

  def params_pop
    @param = @params.pop
    @param
  end
end