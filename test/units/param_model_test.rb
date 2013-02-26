require_relative '../test_helper'

class TestParamModel < MiniTest::Unit::TestCase
  def setup
    @param = Mycommands::Params.new([{"CONFIRM"=>"Confirm exec/ok (ok)"}, {"FILES"=>"Files to remove (*.svn)"}])
  end

  def test_current_param
    assert_equal("Files to remove (*.svn)", @param.current_param.description)
    assert_equal("FILES", @param.current_param.value)
  end

end