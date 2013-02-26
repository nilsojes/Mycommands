require_relative '../test_helper'

class TestCommandModel < MiniTest::Unit::TestCase
  def setup
    @commands = Mycommands::CommandModel.new
  end

  def test_commands
    assert(@commands.commands('Files').all? {|c| c.is_a?(Mycommands::Command)})
  end

  def test_command
    assert_equal('Delete specific files in cwd recursive', @commands.command('Files', 0).description)
  end
end