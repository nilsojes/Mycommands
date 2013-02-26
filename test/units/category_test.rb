require_relative '../test_helper'

class TestCategoryModel < MiniTest::Unit::TestCase
  def setup
    @category = Mycommands::CategoryModel.new
  end

  def test_init
    assert_equal ["Files", "Images", "Search"], @category.categories.map(&:name)
  end

  def test_choice
    @category.choose(1)
    assert_equal ["Permissions", "Symlinks", "Tar"], @category.categories.map(&:name)
  end

  def test_back
    @category.choose(1)
    @category.go_back
    assert_equal ["Files", "Images", "Search"], @category.categories.map(&:name)
  end

  def test_category
    @category.choose(1).choose(1)
    assert_equal("Permissions", @category.category)
  end
end