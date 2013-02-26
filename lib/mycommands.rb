module Mycommands
  LIBPATH = File.expand_path(File.dirname( __FILE__ ))
  ROOTPATH = File.expand_path("..", LIBPATH)
  YMLPATH = (defined?(TEST) && TEST) ? ROOTPATH + '/test' : LIBPATH + '/mycommands'
  $: << LIBPATH

  require 'yaml'
  require 'erb'
  require 'readline'
  require "mycommands/version"
  require 'mycommands/application'
  require 'mycommands/router'
  require 'mycommands/factory'
  autoload :Controller, "mycommands/controllers/controller"
  autoload :ApplicationController, "mycommands/controllers/application_controller"
  autoload :CategoryController, "mycommands/controllers/category_controller"
  autoload :CommandController, "mycommands/controllers/command_controller"
  autoload :ParamController, "mycommands/controllers/param_controller"
  autoload :CategoryModel, "mycommands/models/category"
  autoload :Model, "mycommands/models/model"
  autoload :Category, "mycommands/models/category"
  autoload :CommandModel, "mycommands/models/command"
  autoload :Command, "mycommands/models/command"
  autoload :Params, "mycommands/models/param"
  autoload :Param, "mycommands/models/param"
  autoload :View, "mycommands/views/view"
  autoload :ApplicationView, "mycommands/views/application_view"
  autoload :CategoryView, "mycommands/views/category_view"
  autoload :CommandView, "mycommands/views/command_view"
  autoload :ParamView, "mycommands/views/param_view"
end