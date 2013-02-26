require_relative '../test_helper'
require 'open3'
require 'io/wait'

class TestIntegration < MiniTest::Unit::TestCase
  def test_command_with_params
    output = run_app(%w(1 4 *.exe ok))
    assert_equal("\n    \e[4mCategories\e[0m\n1 - \e[96mFiles\e[0m\n2 - \e[96mImages\e[0m\n3 - \e[96mSearch\e[0m\n\n    \e[4mCategories\e[0m\n1 - \e[96mPermissions\e[0m\n2 - \e[96mSymlinks\e[0m\n3 - \e[96mTar\e[0m\n\n    \e[4mCommands in \"Files\"\e[0m\n4 - \e[92mDelete specific files in cwd recursive\e[0m\n5 - \e[92mList the size of sub folders\e[0m\n\n    \e[4mParameters for command\e[0m\n\e[93m    Files to remove (*.svn)?\e[0m\n\e[93m    Confirm exec/ok (ok)?\e[0m\n\nThe command below has been copied to the clipboard\n\e[92mfind . -name \\*.exe -ok rm {} \\;\e[0m\n\n", output)
  end

  def test_command_without_params
    output = run_app(%w(1 5))
    assert_equal("\n    \e[4mCategories\e[0m\n1 - \e[96mFiles\e[0m\n2 - \e[96mImages\e[0m\n3 - \e[96mSearch\e[0m\n\n    \e[4mCategories\e[0m\n1 - \e[96mPermissions\e[0m\n2 - \e[96mSymlinks\e[0m\n3 - \e[96mTar\e[0m\n\n    \e[4mCommands in \"Files\"\e[0m\n4 - \e[92mDelete specific files in cwd recursive\e[0m\n5 - \e[92mList the size of sub folders\e[0m\n\nThe command below has been copied to the clipboard\n\e[92mdu -h --max-depth=1\e[0m\n\n", output)
  end

  def test_go_back_and_quit
    output = run_app(%w(1 0 r))
    assert_equal("\n    \e[4mCategories\e[0m\n1 - \e[96mFiles\e[0m\n2 - \e[96mImages\e[0m\n3 - \e[96mSearch\e[0m\n\n    \e[4mCategories\e[0m\n1 - \e[96mPermissions\e[0m\n2 - \e[96mSymlinks\e[0m\n3 - \e[96mTar\e[0m\n\n    \e[4mCommands in \"Files\"\e[0m\n4 - \e[92mDelete specific files in cwd recursive\e[0m\n5 - \e[92mList the size of sub folders\e[0m\n\n    \e[4mCategories\e[0m\n1 - \e[96mFiles\e[0m\n2 - \e[96mImages\e[0m\n3 - \e[96mSearch\e[0m\nBye!\n", output)
  end

  private
  def run_app input
    output = ''

    stdin, stdout = Open3.popen2( Mycommands::ROOTPATH + "/bin/mycommands -t")

    while stdout.ready?
      output << stdout.readline
    end

    for i in input
      stdin.puts i
    end

    # Now get whatever else we still have to read:
    stdin.close
    stdout.each_line do |line|
      output << line
    end
    output
  end
end