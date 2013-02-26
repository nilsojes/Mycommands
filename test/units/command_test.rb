require_relative '../test_helper'

class TestCommand < MiniTest::Unit::TestCase
  def setup
    @command = Mycommands::Command.new(["Delete specific files in cwd recursive", ["Files", "find . -name \\FILES -CONFIRM rm {} \\;", {"FILES"=>"Files to remove (*.svn)"}, {"CONFIRM"=>"Confirm exec/ok (ok)"}]])
    @command.params.map {|p| p.substitute ''}
  end

  def test_description
    assert_equal("Delete specific files in cwd recursive", @command.description)
  end

  def test_category
    assert_equal("Files", @command.category)
  end

  def test_command_string
    assert_equal("find . -name \\FILES -CONFIRM rm {} \\;", @command.command_string)
  end

  def test_command_params
    assert(@command.has_params?)
  end

  def test_finished_command
    assert_equal("find . -name \\*.svn -ok rm {} \\;", @command.finished_command)
  end

end