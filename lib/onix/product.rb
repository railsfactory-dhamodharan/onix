module ONIX
  class Product < Base

    attr_reader :node

    def initialize(node = nil)
      if node.kind_of? XML::Node
        @product_node = node
      else
        @product_node = XML::Node.new("Product")
      end 
    end

    def record_reference
      text_content '//Product/RecordReference'
    end

    def record_reference=(val)
      if node = @product_node.find_first('//Product/RecordReference')
        node.content = val
      else
        node = XML::New.new("RecordReference")
        node.content = val
        @product_node << node
      end
    end

    def notification_type
      numeric_content '//Product/NotificationType'
    end

    def notification_type=(val)
      if node = @product_node.find_first('//Product/NotificationType')
        node.content = val
      else
        node = XML::New.new("NotificationType")
        node.content = val
        @product_node << node
      end
    end

    def isbn10
      text_content "//Product/ProductIdentifier/ProductIDType[text()='02']/../IDValue"
    end

    def isbn13
      text_content "//Product/ProductIdentifier/ProductIDType[text()='15']/../IDValue"
    end

    def ean
      text_content "//Product/ProductIdentifier/ProductIDType[text()='03']/../IDValue"
    end

    def product_form
      text_content '//Product/ProductForm'
    end
  end
end

