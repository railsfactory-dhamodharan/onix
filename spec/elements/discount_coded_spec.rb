# coding: utf-8

require 'spec_helper.rb'

describe ONIX::DiscountCoded do

  before(:each) do
    load_doc_and_root("discount_coded.xml")
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

end
