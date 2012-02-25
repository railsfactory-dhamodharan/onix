# coding: utf-8

require 'spec_helper.rb'

describe ONIX::Name do

  before(:each) do
    load_doc_and_root("name.xml")
  end

  it "should correctly convert to a string" do
    name = ONIX::Name.from_xml(@root.to_s)
    name.to_xml.to_s[0,6].should eql("<Name>")
  end

  it "should provide read access to first level attributes" do
    name = ONIX::Name.from_xml(@root.to_s)
    name.person_name_type.should eql(1)
    name.person_name.should eql("Mark Twain")
  end

  it "should provide write access to first level attributes" do
    name = ONIX::Name.new
    name.person_name_type = 4
    name.to_xml.to_s.include?("<PersonNameType>04</PersonNameType>").should be_true
    name.person_name = "Samuel Clemens"
    name.to_xml.to_s.include?("<PersonName>Samuel Clemens</PersonName>").should be_true
  end

end


