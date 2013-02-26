module Mycommands
  class CategoryView < View
    def index
      add_default_routes
      if @category
        header "Categories in \"#{@category}\""
      else
        header "Categories"
      end
      @categories.each_with_index do |(category, value), index|
        choice = @router.add_route(:controller => :Category, :action => :index, :input => (index+1).to_s)
        print "#{choice} - #{category.name.cyan}"
      end
    end
  end
end