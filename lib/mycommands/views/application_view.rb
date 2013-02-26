module Mycommands
  class ApplicationView < View
    def sort_yaml_files
      print "#{@category_file} has been sorted."
      print "#{@command_file} has been sorted."
    end
  end
end