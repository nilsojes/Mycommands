module Mycommands
  class Model
    private
    def default_or_user_yml file
      default_yml = "#{YMLPATH}/#{file}"
      user_yml = "#{ENV['HOME']}/Mycommands/#{file}"
      File.exist?(user_yml) ? user_yml : default_yml
    end
  end
end