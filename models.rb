class HistoryModel
  attr_accessor :history
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
end

class CategoryModel
  attr_accessor :all_categories
  def initialize
    @all_categories = YAML::load(File.open('categories.yml'))
  end

  def categories
    choices = Factory::get('HistoryModel').category_choices
    if choices.empty?
      @categories = @all_categories
    else
      @categories = @all_categories
      for choice in choices
        @categories = @categories.sort[choice][1]
      end
    end
    if @categories
      @categories = @categories.sort.map {|i| i = i[0]}
    else
      nil
    end
  end

  def last_category
    choices = Factory::get('HistoryModel').category_choices
    last_choice = choices.pop
    return nil if last_choice.nil?
    @categories = @all_categories
    if choices.empty?
      category = @categories.sort[last_choice][0]
    else
      for choice in choices
        @categories = @categories.sort[choice][1]
      end
      category = @categories.to_a[last_choice][0]
    end
    category
  end
end

class CommandModel
  attr_accessor :all_commands, :commands, :category, :command, :params
  def initialize
    @all_commands = YAML::load(File.open('commands.yml'))
  end

  def commands
    @commands = @all_commands.to_a.select {|c| c[1][0] == @category}
  end

  def command choice = nil
    if choice.nil?
      @command
    else
      @command = @commands[choice]
    end
  end
end

class ParamModel
  attr_accessor :params, :param, :substituted_params
  def initialize
    command = Factory::get('CommandModel').command
    @params = command[1][2, 100].reverse
    @substituted_params = []
  end

  def params_pop
    @param = @params.pop
    @param
  end
end