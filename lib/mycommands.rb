# -*- encoding : utf-8 -*-
require 'observer'
require 'yaml'
require 'erb'
require 'readline'

Path = File.expand_path(File.dirname( File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__ ))
$: << Path
Debug = ARGV.include? '-D'

require Path + '/mycommands/application'
require Path + '/mycommands/router'
require Path + '/mycommands/factory'
require "mycommands/controllers.rb"
require "mycommands/models.rb"
require "mycommands/views.rb"

Factory::get(:Application).run