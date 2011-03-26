# coding: utf-8

module ONIX
  class WorkIdentifier
    include ROXML
    extend ONIX::ListWriter
    include ONIX::Inflector
    
    xml_name "WorkIdentifier"
    
    xml_reader :work_id_type, :from => "WorkIDType", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :id_type_name, :from => "IDTypeName"
    xml_accessor :id_value, :from => "IDValue"
    list_writer :work_id_type, :list => 16
    
  end
end
