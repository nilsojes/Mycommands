module Mycommands
  class ApplicationView < View
    def copy_yaml_files
      for file in @copied
        print "#{file} has been copied to #{@path}."
      end
      for file in @skipped
        print "#{file} was skipped as it already exist."
      end
    end

    def sort_yaml_files
      print "#{@category_file} has been sorted."
      print "#{@command_file} has been sorted."
    end

    def help
      for option in @options
        print "-#{option[:short]}, --#{option[:verbose]} \t\t #{option[:description]}"
      end
    end
  end
end