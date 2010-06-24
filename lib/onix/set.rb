# coding: utf-8

module ONIX
  class Set
    include ROXML

    xml_name "Set"

    xml_accessor :product_identifiers, :from => "ProductIdentifier", :as => [ONIX::ProductIdentifier]
    xml_accessor :title_of_set, :from => "TitleOfSet"
    
    def initialize
      self.product_identifiers = []
    end
    
    # retrieve the proprietary set ID
    def proprietary_set_id
      product_identifier(1).andand.id_value
    end

    # set a new proprietary set ID
    def proprietary_set_id=(id)
      product_identifier_set(1, id)
    end
    
    # retrieve the 10-digit isbn
    def isbn10
      product_identifier(2).andand.id_value
    end

    # set a new 10-digit isbn
    def isbn10=(id)
      product_identifier_set(2, id)
    end
    
    # retrieve the 13-digit isbn
    def isbn
      product_identifier(15).andand.id_value
    end

    # set a new 13-digit isbn
    def isbn=(id)
      product_identifier_set(15, id)
    end
    
    # retrieve the lccn
    def lccn
      product_identifier(13).andand.id_value
    end

    # set a new lccn
    def lccn=(id)
      product_identifier_set(13, id)
    end
    
    # retrieve the value of a particular ID
    def product_identifier(type)
      identifier = product_identifiers.find { |id| id.product_id_type == type }
    end

    # set the value of a particular ID
    def product_identifier_set(type, value)
      product_identifier_id = product_identifiers.find { |id| id.product_id_type == type }
      
      # create a new set identifier record if we need to
      if product_identifier_id.nil?
        product_identifier_id = ONIX::ProductIdentifier.new
      end
      
      product_identifier_id.product_id_type = type
      product_identifier_id.id_value = value
      
      product_identifiers << product_identifier_id
    end
  end
end
