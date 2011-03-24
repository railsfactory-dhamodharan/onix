# coding: utf-8

module ONIX
  class Set
    include ROXML
    include ONIX::ProductIdentifiers

    xml_name "Set"

    xml_reader :product_identifiers, :from => "ProductIdentifier", :as => [ONIX::ProductIdentifier]
    xml_accessor :title_of_set, :from => "TitleOfSet"
    
    def initialize(options = {})
      options.symbolize_keys!
      self.initialize_product_identifiers(options) # Must be called to setup @product_identifiers array
    end
    
    # Following methods removed os of gem 0.8.9 (not backwards compatible):
    #   original method -> replacement method
    #   proprietary_set_id -> proprietary_id
    #   proprietary_set_id=(id) -> proprietary_id=(id)
    #   product_identifier(type) -> see product_identifiers.rb (eg, use isbn, lccn...)
    #   product_identifier_set(type, value) -> see product_identifiers.rb (eg, use isbn=, lccn=...)
    
  end
end
