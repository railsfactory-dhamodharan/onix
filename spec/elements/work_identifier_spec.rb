# coding: utf-8

require 'spec_helper.rb'

describe ONIX::WorkIdentifier do

  before(:each) do
    load_doc_and_root("work_identifier.xml")
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

  it "should properly initialize attributes when calling new" do
    t = ONIX::WorkIdentifier.new(:work_id_type => 1, :id_value => "value", :id_type_name => "name")
    t.work_id_type.should eql(1)
    t.id_value.should eql("value")
    t.id_type_name.should eql("name")
  end

end
