# coding: utf-8

module ONIX
  class RelatedProduct
    include ROXML

    xml_name "RelatedProduct"

    xml_reader :relation_code, :from => "RelationCode", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_reader :product_identifiers, :from => "ProductIdentifier", :as => [ONIX::ProductIdentifier]
    
    def initialize(options = {})
      options.symbolize_keys!
      self.relation_code = options[:relation_code]
      self.product_identifiers = options[:product_identifiers]
      self.proprietary_id = options[:proprietary_id] if options[:proprietary_id]
    end
    
    def relation_code=(new_value)
      if new_value.nil? || ::ONIX::Lists.list(51).keys.include?(new_value)
        @relation_code = new_value
      else
        raise "Invalid RelationCode #{new_value}"
      end
    end
    
    def product_identifiers=(new_value)
      new_value = [new_value] if new_value.nil? || new_value.is_a?(ONIX::ProductIdentifier)
      if new_value.is_a?(Array)
        # Empty array
        @product_identifiers = []
        # Add any valid value
        new_value.each do |value|
          @product_identifiers << value if value.is_a?(ONIX::ProductIdentifier)
        end
      else
        raise "Invalid ProductIdentifier #{new_value.inspect}"
      end
    end
    
    # retrieve the proprietary ID
    def proprietary_id
      identifier(1).andand.id_value
    end

    # set a new proprietary ID
    def proprietary_id=(value)
      identifier_set(1, value)
    end
    
    private
    
    # find the ProductIdentifier matching a particular type
    def identifier(type)
      @product_identifiers.find { |obj| obj.product_id_type == type }
    end

    # set the value of a particular ProductIdentifier (found by type)
    def identifier_set(type, value)
      obj = identifier(type)

      # create a new product identifier object if we necessary
      if obj.nil?
        obj = ONIX::ProductIdentifier.new
        obj.product_id_type = type
        @product_identifiers << obj
      end

      obj.id_value = value
    end
    
  end
end
