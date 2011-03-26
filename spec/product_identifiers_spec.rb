# coding: utf-8

require File.dirname(__FILE__) + '/spec_helper.rb'

describe ONIX::ProductIdentifiers do
  
  module ONIX
    class FakeEntity
      include ROXML
      include ONIX::ProductIdentifiers
      include ONIX::Inflector
      
      xml_name "FakeEntity"
      xml_reader :product_identifiers, :from => "ProductIdentifier", :as => [ONIX::ProductIdentifier]
      
      def initialize(options = {})
        # Must initialize arrays prior to attributes
        initialize_product_identifiers(options) # @product_identifiers array
        initialize_attributes(options)
      end
    end
  end
  
  before :each do
    @fake = ONIX::FakeEntity.new(:isbn => 123456)
    data_path = File.join(File.dirname(__FILE__),"..","data")
    file1 = File.join(data_path, "fake_entity.xml")
    @doc = Nokogiri::XML::Document.parse(File.read(file1))
    @root = @doc.root
  end
  
  it "should instantiate product identifiers array" do
    @fake.product_identifiers.should be_a(Array)
  end
  
  it "should provide read access to product identifiers" do
    fe = ONIX::FakeEntity.from_xml(@root.to_s)
    fe.proprietary_id.should eql("PROPRIETARY_ID")
    fe.isbn10.should eql("ISBN10")
    fe.isbn.should eql("ISBN13")
    fe.isbn13.should eql("ISBN13")
    fe.ean.should eql("EAN")
    fe.lccn.should eql("LCCN")
  end

  it "should provide write access to product identifiers" do
    id_value = "123456"
    {:proprietary_id => 1, :ean => 3, :isbn10 => 2, :isbn13 => 15, :isbn => 15, :lccn => 13}.each do |key, product_id_type|
      fe = ONIX::FakeEntity.new(key => id_value)
      fe.to_xml.to_s.include?("<ProductIDType>#{sprintf('%02d', product_id_type)}</ProductIDType>").should be_true
      fe.to_xml.to_s.include?("<IDValue>#{id_value}</IDValue>").should be_true
    end
  end
  
  it "should provide write access to product_identifiers array" do
    id = ONIX::ProductIdentifier.new
    id.product_id_type = 1
    id.id_value = "123456"
    fe = ONIX::FakeEntity.new(:product_identifiers => id)
  
    fe.to_xml.to_s.include?("<ProductIdentifier>").should be_true
    fe.to_xml.to_s.include?("<ProductIDType>01</ProductIDType>").should be_true
    fe.to_xml.to_s.include?("<IDValue>123456</IDValue>").should be_true
  
    id = ONIX::ProductIdentifier.new
    id.product_id_type = 2
    id.id_value = "987654"
    fe.product_identifiers << id
  
    fe.to_xml.to_s.include?("<ProductIDType>02</ProductIDType>").should be_true
    fe.to_xml.to_s.include?("<IDValue>987654</IDValue>").should be_true
  end

end
