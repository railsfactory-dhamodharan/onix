module ONIX
  class Base

    private

    def text_content(path)
      n = @node.find_first(path)
      n ? n.content : nil
    end
  end
end
