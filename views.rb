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
  def red_b
    "\e[41m#{self}\e[0m"
  end
  def green
    "\e[92m#{self}\e[0m"
  end
  def yellow
    "\e[93m#{self}\e[0m"
  end
  def yellow_b
    "\e[103m#{self}\e[0m"
  end
  def blue
    "\e[94m#{self}\e[0m"
  end
  def cyan
    "\e[96m#{self}\e[0m"
  end
end

class View
  def header text
    puts "
    "+"#{text}".underline #.yellow_b
  end

  def list items, color = :normal, offset = 0
    items.each_with_index do |(key, value), index|
      puts "#{index+1+offset} - #{key.send color}"
    end
  end
end

class CategoryView < View
  def display_list categories, category
    if category
      header "Categories in \"#{category}\""
    else
      header "Categories"
    end
    list categories, :cyan
  end
end

class CommandView < View
  def display_list commands, category, offset
    header "Commands in \"#{category}\""
    list commands, :green, offset
  end

  def display_item

  end
end

class ParamView < View
  def display_item param
    header :"Parameters for command" if Factory::get('ParamModel').substituted_params.empty?
    puts "#{param}?".yellow
  end
end