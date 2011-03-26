# coding: utf-8

module ONIX
  class RelatedProduct
    include ROXML
    include ONIX::ProductIdentifiers
    extend ONIX::ListWriter
    include ONIX::Inflector
    
    xml_name "RelatedProduct"

    xml_reader :relation_code, :from => "RelationCode", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_reader :product_identifiers, :from => "ProductIdentifier", :as => [ONIX::ProductIdentifier]
    list_writer :relation_code, :list => 51
    
    def initialize(options = {})
      # Must initialize arrays prior to attributes
      initialize_product_identifiers(options) # @product_identifiers array
      initialize_attributes(options)
    end
    
  end
end
