class View
  def header text
    puts "*** #{text} ***"
  end

  def list items
    items.each_with_index do |(key, value), index|
      puts "#{index+1} - #{key}"
    end
  end
end

class CategoryView < View
  def display_list categories
    header :Categories
    list categories
  end
end

class CommandView < View
  def display_list commands
    header :Commands
    list commands
  end

  def display_item

  end
end

class ParamView < View
  def display_item param
    puts "#{param}?"
  end
end