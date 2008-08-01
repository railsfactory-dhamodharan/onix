module ONIX
  class Base

    private

    def numeric_content(path)
      n = text_content(path)
      n ? n.to_i : nil
    end

    def text_content(path)
      n = @node.find_first(path)
      n ? n.content : nil
    end
  end
end
