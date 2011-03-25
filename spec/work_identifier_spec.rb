# coding: utf-8

require File.dirname(__FILE__) + '/spec_helper.rb'

describe ONIX::WorkIdentifier do

  before(:each) do
    data_path = File.join(File.dirname(__FILE__), "..", "data")
    file1     = File.join(data_path, "work_identifier.xml")
    @doc      = Nokogiri::XML::Document.parse(File.read(file1))
    @root     = @doc.root
  end

  it "should correctly convert to a string" do
    t = ONIX::WorkIdentifier.from_xml(@root.to_s)
    t.to_xml.to_s[0,16].should eql("<WorkIdentifier>")
  end

  it "should provide read access to first level attributes" do
    t = ONIX::WorkIdentifier.from_xml(@root.to_s)
    t.work_id_type.should eql(1)
    t.id_type_name.should eql("Proprietary Publisher Scheme")
    t.id_value.should eql("ABC123")
  end

  it "should provide write access to first level attributes" do
    t = ONIX::WorkIdentifier.new

    t.work_id_type = 1
    t.to_xml.to_s.include?("<WorkIDType>01</WorkIDType>").should be_true

    t.id_type_name = "Proprietary Publisher Scheme"
    t.to_xml.to_s.include?("<IDTypeName>Proprietary Publisher Scheme</IDTypeName>").should be_true

    t.id_value = "ABC123"
    t.to_xml.to_s.include?("<IDValue>ABC123</IDValue>").should be_true
  end
  
  it "should raise error writing work_id_type value not in list" do
    t = ONIX::WorkIdentifier.new
    lambda {t.work_id_type = 999}.should raise_error
    lambda {ONIX::WorkIdentifier.new(:work_id_type => 999)}.should raise_error
  end

end
