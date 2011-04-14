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

# For more formating options:
# http://en.wikipedia.org/wiki/ANSI_escape_code#Codes

class String
  def normal
    self
  end
  def underline
    "\e[4m#{self}\e[0m"
  end
  def black
    "\e[30m#{self}\e[0m"
  end
  def red
    "\e[91m#{self}\e[0m"
  end
  def green
    "\e[92m#{self}\e[0m"
  end
  def yellow
    "\e[93m#{self}\e[0m"
  end
  def blue
    "\e[94m#{self}\e[0m"
  end
  def cyan
    "\e[96m#{self}\e[0m"
  end
end

class View
  def initialize
    @router = Factory::get(:Router)
  end

  def header text
    puts "\n    "+"#{text}".underline
  end

  def add_default_routes
    @router.add_route(:match => '0', :controller => "Category", :action => "index", :input => '0')
  end
end

class CategoryView < View
  def index categories, category
    add_default_routes
    if category
      header "Categories in \"#{category}\""
    else
      header "Categories"
    end
    categories.each_with_index do |(key, value), index|
      puts "#{index+1} - #{key.cyan}"
      @router.add_route(:match => (index+1).to_s, :controller => :Category, :action => :index, :input => (index+1).to_s)
    end
  end
end

class CommandView < View
  def index commands, category, offset
    add_default_routes
    header "Commands in \"#{category}\""
    commands.each_with_index do |(key, value), index|
      puts "#{index+1+offset} - #{key.green}"
      @router.add_route(:match => (index+1+offset).to_s, :controller => :Command, :action => :show, :input => (index+1).to_s)
    end
  end

  def show command
    puts "\nThe command below has been copied to the clipboard
#{command.green}\n\n"
  end

  def empty_category category
    puts "No commands or categories in \"#{category}\""
  end
end

class ParamView < View
  def show param
    header :"Parameters for command" if Factory::get('ParamModel').substituted_params.empty?
    puts "    #{param}?".yellow
    @router.add_route(:match => '.|^', :controller => :Param, :action => :update)
  end
end