# coding: utf-8

module ONIX
  class Complexity
    include ROXML
    extend ONIX::ListWriter
    include ONIX::Inflector
    
    xml_name "Complexity"
    
    xml_accessor :complexity_scheme_identifier, :from => "ComplexitySchemeIdentifier", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :complexity_code, :from => "ComplexityCode"
    list_writer :complexity_scheme_identifier, :list => 32
  end
end
