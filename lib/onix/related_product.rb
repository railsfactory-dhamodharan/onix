# coding: utf-8

module ONIX
  class RelatedProduct
    include ROXML
    include ONIX::ProductIdentifiers
    extend ONIX::ListWriter
    
    xml_name "RelatedProduct"

    xml_reader :relation_code, :from => "RelationCode", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_reader :product_identifiers, :from => "ProductIdentifier", :as => [ONIX::ProductIdentifier]
    list_writer :relation_code, 51
    
    def initialize(options = {})
      options.symbolize_keys!
      self.relation_code = options[:relation_code]
      self.initialize_product_identifiers(options) # Must be called to setup @product_identifiers array
    end
    
  end
end
