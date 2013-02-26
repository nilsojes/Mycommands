require_relative '../test_helper'

class TestRouter < MiniTest::Unit::TestCase
  def setup
    @router = Mycommands::Router.new
  end

  def test_init
    assert_equal(false, @router.route('1'))
  end

  def test_add_and_clear_route
    @router.add_route(:controller => :Category, :action => :index, :input => '1')
    assert_equal([:Category, :index, "1"], @router.route('1'))
    @router.clear_routes
    assert_equal(false, @router.route('1'))
  end
end