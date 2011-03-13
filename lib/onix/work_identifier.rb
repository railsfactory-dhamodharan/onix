# coding: utf-8

module ONIX
  class WorkIdentifier
    include ROXML
    
    xml_name "WorkIdentifier"
    
    xml_reader :work_id_type, :from => "WorkIDType", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :id_type_name, :from => "IDTypeName"
    xml_accessor :id_value, :from => "IDValue"
    
    def initialize(options = {})
      options.symbolize_keys!
      self.work_id_type = options[:work_id_type]
      @id_type_name = options[:id_type_name]
      @id_value = options[:id_value]
    end
    
    def work_id_type=(new_work_id_type)
      if new_work_id_type.nil? || ::ONIX::Lists.list(16).keys.include?(new_work_id_type)
        @work_id_type = new_work_id_type
      else
        raise "Invalid WorkIDType #{new_work_id_type}"
      end
    end
  end
end
