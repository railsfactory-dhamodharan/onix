# coding: utf-8

module ONIX
  class Audience
    include ROXML
    extend ONIX::ListWriter
    include ONIX::Inflector
    
    xml_name "Audience"
    
    xml_accessor :audience_code_type, :from => "AudienceCodeType", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :audience_code_type_name, :from => "AudienceCodeTypeName"
    xml_accessor :audience_code_value, :from => "AudienceCodeValue"
    list_writer :audience_code_type, :list => 29
  end
end
