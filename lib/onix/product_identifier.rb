# coding: utf-8

module ONIX
  class ProductIdentifier
    include ROXML
    extend ONIX::ListWriter
    include ONIX::Inflector

    xml_name "ProductIdentifier"

    xml_reader :product_id_type, :from => "ProductIDType", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :id_value, :from => "IDValue"
    list_writer :product_id_type, :list => 5
    
  end
end
