# coding: utf-8

require File.dirname(__FILE__) + '/spec_helper.rb'

describe ONIX::Audience do

  before(:each) do
    data_path = File.join(File.dirname(__FILE__), "..", "data")
    file1     = File.join(data_path, "audience.xml")
    @doc      = Nokogiri::XML::Document.parse(File.read(file1))
    @root     = @doc.root
  end

  it "should correctly convert to a string" do
    t = ONIX::Audience.from_xml(@root.to_s)
    t.to_xml.to_s[0,10].should eql("<Audience>")
  end

  it "should provide read access to first level attributes" do
    t = ONIX::Audience.from_xml(@root.to_s)
    t.audience_code_type.should eql(2)
    t.audience_code_type_name.should eql("Guided Reading Level")
    t.audience_code_value.should eql("G")
  end

  it "should provide write access to first level attributes" do
    t = ONIX::Audience.new

    t.audience_code_type = 19
    t.to_xml.to_s.include?("<AudienceCodeType>19</AudienceCodeType>").should be_true

    t.audience_code_value = "480"
    t.to_xml.to_s.include?("<AudienceCodeValue>480</AudienceCodeValue>").should be_true
  end
  
  it "should raise error writing audience_code_type value not in list" do
    t = ONIX::Audience.new
    lambda {t.audience_code_type = 999}.should raise_error
    lambda {ONIX::Audience.new(:audience_code_type => 999)}.should raise_error
  end
  
  it "should properly initialize attributes when calling new" do
    t = ONIX::Audience.new(:audience_code_type => 2, :audience_code_type_name => "proprietary", :audience_code_value => "value")
    t.audience_code_type.should eql(2)
    t.audience_code_type_name.should eql("proprietary")
    t.audience_code_value.should eql("value")
  end

end
