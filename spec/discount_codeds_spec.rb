# coding: utf-8

require File.dirname(__FILE__) + '/spec_helper.rb'

describe ONIX::DiscountCodeds do
  
  module ONIX
    class FakeDiscountEntity
      include ROXML
      include ONIX::DiscountCodeds
      
      xml_name "FakeDiscountEntity"
      xml_reader :discount_codeds, :from => "DiscountCoded", :as => [ONIX::DiscountCoded]
      
      def initialize(options = {})
        initialize_discount_codeds(options) # @discount_codeds array
      end
    end
  end
  
  before :each do
    @fake = ONIX::FakeDiscountEntity.new(:proprietary => 123456)
    data_path = File.join(File.dirname(__FILE__),"..","data")
    file = File.join(data_path, "fake_entity.xml")
    @doc = Nokogiri::XML::Document.parse(File.read(file))
    @root = @doc.root
  end
  
  it "should instantiate discount_codeds array" do
    @fake.discount_codeds.should be_a(Array)
  end
  
  it "should provide read access to discount_codeds" do
    fe = ONIX::FakeDiscountEntity.from_xml(@root.to_s)
    wid = fe.find_discount_coded(2)
    wid.discount_code.should eql("PROPRIETARY_CODE")
    wid = fe.find_discount_coded(:proprietary)
    wid.discount_code.should eql("PROPRIETARY_CODE")
    wid = fe.find_discount_coded(:bic)
    wid.discount_code.should eql("BIC_CODE")
  end

  it "should provide write access to discount_codeds by discount_code_type" do
    discount_code = "123456"
    {:bic => 1, :proprietary => 2, :boeksoort => 3, :german => 4}.each do |key, discount_code_type|
      fe = ONIX::FakeDiscountEntity.new
      fe.set_discount_coded(discount_code_type, discount_code)
      fe.to_xml.to_s.include?("<DiscountCodeType>#{sprintf('%02d', discount_code_type)}</DiscountCodeType>").should be_true
      fe.to_xml.to_s.include?("<DiscountCode>#{discount_code}</DiscountCode>").should be_true
    end
  end
  
  it "should provide write access to discount_codeds by key" do
    discount_code = "123456"
    {:bic => 1, :proprietary => 2, :boeksoort => 3, :german => 4}.each do |key, discount_code_type|
      fe = ONIX::FakeDiscountEntity.new
      fe.set_discount_coded(key, discount_code)
      fe.to_xml.to_s.include?("<DiscountCodeType>#{sprintf('%02d', discount_code_type)}</DiscountCodeType>").should be_true
      fe.to_xml.to_s.include?("<DiscountCode>#{discount_code}</DiscountCode>").should be_true
    end
  end
  
  it "should fail to write discount_coded with invalid discount_code_type" do
    discount_code = "123456"
    discount_code_type = 99
    fe = ONIX::FakeDiscountEntity.new
    lambda {fe.set_discount_coded(discount_code_type, discount_code)}.should raise_error(ArgumentError)
  end
  
  it "should fail to write discount_coded with invalid key" do
    discount_code = "123456"
    key = "bad_key"
    fe = ONIX::FakeDiscountEntity.new
    lambda {fe.set_discount_coded(key, discount_code)}.should raise_error(ArgumentError)
  end
  
  it "should provide write access to discount_codeds array" do
    id = ONIX::DiscountCoded.new
    id.discount_code_type = 1
    id.discount_code = "123456"
    fe = ONIX::FakeDiscountEntity.new(:discount_codeds => id)
  
    fe.to_xml.to_s.include?("<DiscountCoded>").should be_true
    fe.to_xml.to_s.include?("<DiscountCodeType>01</DiscountCodeType>").should be_true
    fe.to_xml.to_s.include?("<DiscountCode>123456</DiscountCode>").should be_true
  
    id = ONIX::DiscountCoded.new
    id.discount_code_type = 2
    id.discount_code = "987654"
    fe.discount_codeds << id
  
    fe.to_xml.to_s.include?("<DiscountCodeType>02</DiscountCodeType>").should be_true
    fe.to_xml.to_s.include?("<DiscountCode>987654</DiscountCode>").should be_true
  end

end
