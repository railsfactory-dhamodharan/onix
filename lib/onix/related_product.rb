# coding: utf-8

module ONIX
  class RelatedProduct
    include ROXML
    include ONIX::ProductIdentifiers

    xml_name "RelatedProduct"

    xml_reader :relation_code, :from => "RelationCode", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_reader :product_identifiers, :from => "ProductIdentifier", :as => [ONIX::ProductIdentifier]
    
    def initialize(options = {})
      options.symbolize_keys!
      self.relation_code = options[:relation_code]
      self.initialize_product_identifiers(options) # Must be called to setup @product_identifiers array
    end
    
    def relation_code=(new_value)
      if new_value.nil? || ::ONIX::Lists.list(51).keys.include?(new_value)
        @relation_code = new_value
      else
        raise "Invalid RelationCode #{new_value}"
      end
    end
    
  end
end
