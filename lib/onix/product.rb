module ONIX
  class Product < Base
    def initialize(node = nil)
      if node.kind_of? XML::Node
        @node = node
      else
        @node = XML::Node.new
      end 
    end

    def product_form
      text_content '//Product/ProductForm'
    end
  end
end

