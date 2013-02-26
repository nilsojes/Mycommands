module Mycommands
  class ApplicationController < Controller
    def sort_yaml_files
      @category_file = Factory.get(:CategoryModel).sort_yaml_file!
      @command_file = Factory.get(:CommandModel).sort_yaml_file!
      render
    end

    private
    def set_model
      false
    end
  end
end

