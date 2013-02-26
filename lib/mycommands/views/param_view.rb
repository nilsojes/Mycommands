module Mycommands
  class ParamView < View
    def show
      header :"Parameters for command" if @params.current_param_index == 0
      print "    #{@param}?".yellow
      @router.add_route(:match => '.|^', :controller => :Param, :action => :update, :input => @result)
    end
  end
end