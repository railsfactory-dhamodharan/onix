# coding: utf-8

require 'spec_helper.rb'

describe ONIX::Audience do

  before(:each) do
    load_doc_and_root("audience.xml")
  end

  it "should correctly convert to a string" do
    a = ONIX::Audience.from_xml(@root.to_s)
    a.to_xml.to_s[0,10].should eql("<Audience>")
  end

  it "should provide read access to first level attributes" do
    a = ONIX::Audience.from_xml(@root.to_s)
    a.audience_code_type.should eql(2)
    a.audience_code_type_name.should eql("Guided Reading Level")
    a.audience_code_value.should eql("G")
  end

  it "should provide write access to first level attributes" do
    a = ONIX::Audience.new

    a.audience_code_type = 19
    a.to_xml.to_s.include?("<AudienceCodeType>19</AudienceCodeType>").should be_true

    a.audience_code_value = "480"
    a.to_xml.to_s.include?("<AudienceCodeValue>480</AudienceCodeValue>").should be_true
  end

end
