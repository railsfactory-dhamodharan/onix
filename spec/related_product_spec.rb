# coding: utf-8

require File.dirname(__FILE__) + '/spec_helper.rb'

context "ONIX::RelatedProduct" do

  before(:each) do
    data_path = File.join(File.dirname(__FILE__),"..","data")
    file1    = File.join(data_path, "related_product.xml")
    @doc = Nokogiri::XML::Document.parse(File.read(file1))
    @root = @doc.root
  end

  specify "should correctly convert to a string" do
    rp = ONIX::RelatedProduct.from_xml(@root.to_s)
    rp.to_xml.to_s[0,16].should eql("<RelatedProduct>")
  end

  specify "should provide read access to relation_code" do
    rp = ONIX::RelatedProduct.from_xml(@root.to_s)
    rp.relation_code.should eql(5)
  end

  specify "should provide write access to relation_code" do
    rp = ONIX::RelatedProduct.new(:relation_code => 1)
    rp.to_xml.to_s.include?("<RelationCode>01</RelationCode>").should be_true
    
    rp.relation_code = 2
    rp.to_xml.to_s.include?("<RelationCode>02</RelationCode>").should be_true
  end
  
  specify "should provide read access to proprietary_id" do
    rp = ONIX::RelatedProduct.from_xml(@root.to_s)
    rp.proprietary_id.should eql("123456")
  end
  
  specify "should provide write access to proprietary_id" do
    rp = ONIX::RelatedProduct.new(:proprietary_id => 123456)
    rp.to_xml.to_s.include?("<ProductIDType>01</ProductIDType>").should be_true
    rp.to_xml.to_s.include?("<IDValue>123456</IDValue>").should be_true
  end
  
  specify "should provide write access to product_identifiers array" do
    id = ONIX::ProductIdentifier.new
    id.product_id_type = 1
    id.id_value = "123456"
    rp = ONIX::RelatedProduct.new(:product_identifiers => id)
    
    rp.to_xml.to_s.include?("<ProductIdentifier>").should be_true
    rp.to_xml.to_s.include?("<ProductIDType>01</ProductIDType>").should be_true
    rp.to_xml.to_s.include?("<IDValue>123456</IDValue>").should be_true
    
    id = ONIX::ProductIdentifier.new
    id.product_id_type = 2
    id.id_value = "987654"
    rp.product_identifiers << id
    
    rp.to_xml.to_s.include?("<ProductIDType>02</ProductIDType>").should be_true
    rp.to_xml.to_s.include?("<IDValue>987654</IDValue>").should be_true
  end

end
