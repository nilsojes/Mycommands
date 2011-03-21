class HistoryModel
  attr_accessor :history
  def initialize
    @history = []
  end

  def add *dispatch_args
    @history.push dispatch_args
  end

  def back
    puts "History before pop #{@history.inspect}"
    @history.pop
    puts "History after pop #{@history.inspect}"
  end

  def category_choices
    @history.select {|h| h[0]=='Category'}.map {|h| h=h[2]}.select{|h| !h.nil?}.map {|h| h=h.to_i-1}
  end
end

class CategoryModel
  attr_accessor :all_categories, :choices
  def initialize
    @choices = []
    @all_categories = YAML::load(File.open('/home/nils/dev/mycommands/categories.yml'))
  end

  def categories
#    debugger
    if @choices.empty?
      @categories = @all_categories
    else
#      convert_choice
      @categories = @all_categories
      choices = Factory::get('HistoryModel').category_choices
      puts Factory::get('HistoryModel').history.inspect
      puts choices.inspect
      for choice in choices
        @categories = @categories.sort[choice][1]
      end
        puts @categories.inspect
    end
    @categories = @categories.sort.map {|i| i = i[0]}
#    @categories
  end

  def convert_choice
    if @choices.last.class == Fixnum
      choice = @categories[@choices.last]
      @choices.pop
      @choices = @choices.push choice
    end
  end
end

class CommandModel
  attr_accessor :all_commands, :commands, :category, :choice
  def initialize
    @all_commands = YAML::load(File.open('/home/nils/dev/mycommands/commands.yml'))
  end

  def commands
#    debugger
    @commands = @all_commands.to_a.select {|c| c[1][0] == @category}
  end

  def command choice
    @command = @commands[choice]
  end
end