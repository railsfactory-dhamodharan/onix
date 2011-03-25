# coding: utf-8

module ONIX
  class WorkIdentifier
    include ROXML
    extend ONIX::ListWriter
    
    xml_name "WorkIdentifier"
    
    xml_reader :work_id_type, :from => "WorkIDType", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :id_type_name, :from => "IDTypeName"
    xml_accessor :id_value, :from => "IDValue"
    list_writer :work_id_type, 16
    
    def initialize(options = {})
      options.symbolize_keys!
      self.work_id_type = options[:work_id_type]
      @id_type_name = options[:id_type_name]
      @id_value = options[:id_value]
    end
    
  end
end
