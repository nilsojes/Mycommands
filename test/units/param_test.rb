require_relative '../test_helper'

class TestParam < MiniTest::Unit::TestCase
  def setup
    @param = Mycommands::Param.new({"CONFIRM"=>"Confirm exec/ok (ok)"})
  end

  def test_description
    assert_equal("Confirm exec/ok (ok)", @param.description)
  end

  def test_value
    assert_equal("CONFIRM", @param.value)
  end

  def test_substitute
    @param.substitute('')
    assert_equal('ok', @param.substituted)
    @param.substitute('test')
    assert_equal('test', @param.substituted)
  end

end