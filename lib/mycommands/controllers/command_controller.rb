module Mycommands
  class CommandController < Controller
    def index category
      @category = category
      @commands = @model.commands(category)
      render unless @commands.empty?
    end

    def show choice
      require 'clipboard'
      @command = @model.command @category, choice
      if @command.has_params?
        Factory::get(:ParamController).show(@command.params)
        return
      end
      render
      Clipboard.copy @command.command_string
      exit
    end

    def update
      render :show
      Clipboard.copy @command.finished_command
      exit
    end
  end
end

