module Mycommands
  class Factory
    @@objects = []
    def self.get _class
      for object in @@objects
        return object if object.class == eval(_class.to_s)
      end
      object = eval(_class.to_s).new
      @@objects.push object
      object
    end
  end
end