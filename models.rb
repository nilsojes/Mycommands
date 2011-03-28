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
  attr_reader :count
  def initialize
    default_yml = Path+'/categories.yml'
    user_yml = ENV['HOME']+'/Mycommands/categories.yml'
    yml = File.exist?(user_yml) ? user_yml : default_yml
    @all_categories = YAML::load(File.open(yml))
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
      @count = @categories.size
      @categories
    else
      nil
    end
  end

  def last_category
    choices = Factory::get(:HistoryModel).category_choices
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
  attr_accessor :category
  attr_reader :command
  def initialize
    default_yml = Path+'/commands.yml'
    user_yml = ENV['HOME']+'/Mycommands/commands.yml'
    yml = File.exist?(user_yml) ? user_yml : default_yml
    @all_commands = YAML::load(File.open(yml))
  end

  def commands
    @commands = @all_commands.to_a.select {|c| c[1][0] == @category}
  end

  def set_command choice
    @command = @commands[choice]
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

  def set_params
    @params = Factory::get(:CommandModel).command_params
  end

  def params_pop
    @param = @params.pop
    @param
  end
end