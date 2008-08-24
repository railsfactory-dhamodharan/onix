module ONIX
  class Base

    def to_s
      @root_node.to_s
    end

    private

    def date_content(path)
      n = root.find_first(root.path + path)
      n ? Date.parse(n.content) : nil
    rescue
      nil
    end

    def numeric_content(path)
      n = text_content(path)
      n ? n.to_i : nil
    end

    def text_content(path)
      n = root.find_first(root.path + path)
      n ? n.content : nil
    end

    def text_content_array(path)
      root.find(root.path + path).collect do |n|
        n.content
      end
    end

    def root
      @root_node
    end
  end
end