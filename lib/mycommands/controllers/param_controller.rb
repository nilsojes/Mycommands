module Mycommands
  class ParamController < Controller
    def show params = nil
      @params ||= params
      @param = @params.current_param.description
      render
    end

    def update input
      @params.current_param.substitute input
      @params.next_param
      if @params.all_substituted?
        @application.dispatch([:Command, :update])
      else
        @application.dispatch([:Param, :show])
      end
    end

    private
    def set_model
      false
    end
  end
end

