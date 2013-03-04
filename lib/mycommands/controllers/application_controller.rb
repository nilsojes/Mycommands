require 'fileutils'

module Mycommands
  class ApplicationController < Controller
    def sort_yaml_files
      @category_file = Factory.get(:CategoryModel).sort_yaml_file!
      @command_file = Factory.get(:CommandModel).sort_yaml_file!
      render
    end

    def copy_yaml_files
      Dir.chdir(YMLPATH)
      @path = "#{ENV['HOME']}/Mycommands"
      @copied = []
      @skipped = []
      FileUtils.mkdir(@path) unless File.exist?(@path)
      Dir.glob('*.yml').each do |file|
        unless File.exists?("#{@path}/#{file}")
          FileUtils.cp(file, @path)
          @copied << file
        else
          @skipped << file
        end
      end
      render
    end

    def print_version
      puts "Mycommands #{VERSION}"
    end

    def help
      @options = Application::OPTIONS
      render
    end

    private
    def set_model
      false
    end
  end
end

