module ONIX
  class Base

    private

    def numeric_content(path)
      n = text_content(path)
      n ? n.to_i : nil
    end

    def text_content(path)
      n = root.find_first(path)
      n ? n.content : nil
    end

    def text_content_array(path)
      root.find(path).collect do |n|
        n.content
      end
    end

    def root
      @root_node
    end
  end
end
