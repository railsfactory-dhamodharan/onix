# coding: utf-8

require File.dirname(__FILE__) + '/spec_helper.rb'

describe ONIX::DiscountCoded do

  before(:each) do
    data_path = File.join(File.dirname(__FILE__), "..", "data")
    file1     = File.join(data_path, "discount_coded.xml")
    @doc      = Nokogiri::XML::Document.parse(File.read(file1))
    @root     = @doc.root
  end

  it "should correctly convert to a string" do
    t = ONIX::DiscountCoded.from_xml(@root.to_s)
    t.to_xml.to_s[0,15].should eql("<DiscountCoded>")
  end

  it "should provide read access to first level attributes" do
    t = ONIX::DiscountCoded.from_xml(@root.to_s)
    t.discount_code_type.should eql(2)
    t.discount_code_type_name.should eql("Proprietary Scheme")
    t.discount_code.should eql("ABC123")
  end

  it "should provide write access to first level attributes" do
    t = ONIX::DiscountCoded.new

    t.discount_code_type = 1
    t.to_xml.to_s.include?("<DiscountCodeType>01</DiscountCodeType>").should be_true

    t.discount_code_type_name = "BIC Scheme"
    t.to_xml.to_s.include?("<DiscountCodeTypeName>BIC Scheme</DiscountCodeTypeName>").should be_true

    t.discount_code = "ABC123"
    t.to_xml.to_s.include?("<DiscountCode>ABC123</DiscountCode>").should be_true
  end
  
  it "should raise error writing discount_code_type value not in list" do
    t = ONIX::DiscountCoded.new
    lambda {t.discount_code_type = 999}.should raise_error
    lambda {ONIX::DiscountCoded.new(:discount_code_type => 999)}.should raise_error
  end
  
  it "should properly initialize attributes when calling new" do
    t = ONIX::DiscountCoded.new(:discount_code_type => 1, :discount_code => "value", :discount_code_type_name => "name")
    t.discount_code_type.should eql(1)
    t.discount_code.should eql("value")
    t.discount_code_type_name.should eql("name")
  end

end
