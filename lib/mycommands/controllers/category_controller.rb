module Mycommands
  class CategoryController < Controller
    def index choice = nil
      if choice == '0'
        @model.go_back
      elsif !choice.nil?
        @model.choose choice
      end
      @categories = @model.categories
      render if @categories
      Factory::get(:CommandController).index(@model.category)
    end
  end
end

