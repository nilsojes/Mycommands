require_relative '../test_helper'

class TestFactory < MiniTest::Unit::TestCase
  def test_get
    category = Mycommands::Factory.get(:CategoryModel)
    assert_equal(Mycommands::CategoryModel, category.class)
    assert_equal(category.object_id, Mycommands::Factory.get(:CategoryModel).object_id)
  end
end