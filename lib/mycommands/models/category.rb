module Mycommands
  class CategoryModel < Model
    def initialize
      @choices = []
    end

    def choose choice
      @choices.push choice.to_i - 1
      self
    end

    def go_back
      @choices.pop
      self
    end

    def categories choices = @choices
      categories = choices.inject(all_categories) {|categories, choice| categories = categories[choice].children}
      return nil if categories.nil?
      categories
    end

    def category
      return nil if @choices.empty?
      categories(@choices[0..-2])[@choices[-1]].name
    end

    def sort_yaml_file!
      category_hash = all_categories.inject({}) {|category_hash, c| category_hash.merge!(c.to_hash)}
      file = File.open(default_or_user_yml('categories.yml'), 'w')
      file.write(category_hash.to_yaml)
      file.path
    end

    private
    def all_categories
      @all_categories ||= load_categories.sort
    end

    def load_categories
      YAML::load(File.open(default_or_user_yml('categories.yml'))).map {|c| Category.new(c)}
    end
  end

  class Category
    def initialize category
      @category = category
      if has_children?
        self.children = children.to_a.map{|c| Category.new(c)}.sort
      end
    end

    def children
      @category[1]
    end

    def children= children
      @category[1] = children
    end

    def has_children?
      !children.nil?
    end

    def name
      @category[0]
    end

    def <=> other
      self.name <=> other.name
    end

    def to_hash
      {@category[0] => has_children? ? children.inject({}) {|category_hash, c| category_hash.merge!(c.to_hash)} : nil }
    end
  end
end