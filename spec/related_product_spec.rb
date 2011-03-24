# coding: utf-8

require File.dirname(__FILE__) + '/spec_helper.rb'

describe ONIX::RelatedProduct do

  before(:each) do
    data_path = File.join(File.dirname(__FILE__),"..","data")
    file1    = File.join(data_path, "related_product.xml")
    @doc = Nokogiri::XML::Document.parse(File.read(file1))
    @root = @doc.root
  end

  it "should correctly convert to a string" do
    rp = ONIX::RelatedProduct.from_xml(@root.to_s)
    rp.to_xml.to_s[0,16].should eql("<RelatedProduct>")
  end

  it "should provide read access to relation_code" do
    rp = ONIX::RelatedProduct.from_xml(@root.to_s)
    rp.relation_code.should eql(5)
  end

  it "should provide write access to relation_code" do
    rp = ONIX::RelatedProduct.new(:relation_code => 1)
    rp.to_xml.to_s.include?("<RelationCode>01</RelationCode>").should be_true
    
    rp.relation_code = 2
    rp.to_xml.to_s.include?("<RelationCode>02</RelationCode>").should be_true
  end
  
  # This is essentially testing product_identifers.rb module
  it "should provide read access to proprietary_id" do
    rp = ONIX::RelatedProduct.from_xml(@root.to_s)
    rp.proprietary_id.should eql("123456")
  end
  
  # This is essentially testing product_identifers.rb module
  it "should provide write access to proprietary_id" do
    rp = ONIX::RelatedProduct.new(:proprietary_id => 123456)
    rp.to_xml.to_s.include?("<ProductIDType>01</ProductIDType>").should be_true
    rp.to_xml.to_s.include?("<IDValue>123456</IDValue>").should be_true
  end

end
