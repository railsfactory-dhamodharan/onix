module ONIX
  class Product < Base
    def initialize(node = nil)
      if node.kind_of? XML::Node
        @node = node
      else
        @node = XML::Node.new
      end 
    end

    def record_reference
      text_content '//Product/RecordReference'
    end

    def notification_type
      numeric_content '//Product/NotificationType'
    end

    def isbn10
      text_content "//Product/ProductIdentifier/ProductIDType[text()='02']//following-sibling::IDValue"
    end

    def isbn13
      text_content "//Product/ProductIdentifier/ProductIDType[text()='15']//following-sibling::IDValue"
    end

    def ean
      text_content "//Product/ProductIdentifier/ProductIDType[text()='03']//following-sibling::IDValue"
    end

    def product_form
      text_content '//Product/ProductForm'
    end
  end
end

