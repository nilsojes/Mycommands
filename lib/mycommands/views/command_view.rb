module Mycommands
  class CommandView < View
    def index
      add_default_routes
      header "Commands in \"#{@category}\""
      @commands.each_with_index do |(command, value), index|
        choice = @router.add_route(:controller => :Command, :action => :show, :input => index.to_s)
        print "#{choice} - #{command.description.green}"
      end
    end

    def show
      print "\nThe command below has been copied to the clipboard
#{@command.finished_command.green}\n\n"
    end

    def empty_category category
      print "No commands or categories in \"#{category}\""
    end
  end
end