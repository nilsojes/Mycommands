# For more formating options:
# http://en.wikipedia.org/wiki/ANSI_escape_code#Codes

class String
  def normal
    self
  end
  def underline
    "\e[4m#{self}\e[0m"
  end
  def black
    "\e[30m#{self}\e[0m"
  end
  def red
    "\e[91m#{self}\e[0m"
  end
  def green
    "\e[92m#{self}\e[0m"
  end
  def yellow
    "\e[93m#{self}\e[0m"
  end
  def blue
    "\e[94m#{self}\e[0m"
  end
  def cyan
    "\e[96m#{self}\e[0m"
  end
end

module Mycommands

  class Printer
    def print string
      puts string
    end
  end

  class View
    def initialize printer = Factory::get(:Printer)
      @router = Factory::get(:Router)
      @printer = printer
    end

    def print string
      @printer.print string
    end

    def header text
      print "\n    "+"#{text}".underline
    end

    def add_default_routes
      @router.add_route(:match => '0', :controller => "Category", :action => "index", :input => '0')
    end
  end
end