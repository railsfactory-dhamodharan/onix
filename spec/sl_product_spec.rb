# coding: utf-8

require File.dirname(__FILE__) + '/spec_helper.rb'
require 'date'

context "ONIX::SLProduct" do

  before(:each) do
    @data_path = File.join(File.dirname(__FILE__),"..","data")
    file1    = File.join(@data_path, "sl_product.xml")
    @doc     = Nokogiri::XML::Document.parse(File.read(file1))
    @product_node = @doc.root
  end

  specify "should provide read access to attributes" do
    @product  = ONIX::Product.from_xml(@product_node.to_s)
    @sl       = ONIX::SLProduct.new(@product)

    @sl.record_reference.should eql("200002")
    @sl.notification_type.should eql(3)
    @sl.product_form.should eql("BB")
    @sl.number_of_pages.should eql(32)
    @sl.basic_main_subject.should eql("JNF053090")
    @sl.publishing_status.should eql(4)
    @sl.publication_date.should eql(Date.civil(2007,8,1))
    @sl.related_products.should be_a(Array)
    @sl.related_products[0].should be_a(ONIX::RelatedProduct)
    @sl.related_products[0].relation_code.should eql(5)
  end

  specify "should provide write access to attributes" do
    sl = ONIX::SLProduct.new

    sl.notification_type = 3
    sl.to_xml.to_s.include?("<NotificationType>03</NotificationType>").should be_true

    sl.record_reference = "200002"
    sl.to_xml.to_s.include?("<RecordReference>200002</RecordReference>").should be_true

    sl.product_form = "BB"
    sl.to_xml.to_s.include?("<ProductForm>BB</ProductForm>").should be_true

    sl.number_of_pages = 32
    sl.to_xml.to_s.include?("<NumberOfPages>32</NumberOfPages>").should be_true

    sl.basic_main_subject = "JNF053090"
    sl.to_xml.to_s.include?("<BASICMainSubject>JNF053090</BASICMainSubject>").should be_true

    sl.publishing_status = 4
    sl.to_xml.to_s.include?("<PublishingStatus>04</PublishingStatus>").should be_true

    sl.publication_date = Date.civil(2007,8,1)
    sl.to_xml.to_s.include?("<PublicationDate>20070801</PublicationDate>").should be_true
    
    id = ONIX::ProductIdentifier.new
    id.product_id_type = 1
    id.id_value = "123456"
    sl.related_products = [ONIX::RelatedProduct.new(:relation_code => 1, :product_identifiers => id)]
    sl.related_products << ONIX::RelatedProduct.new(:relation_code => 2, :product_identifiers => id)
    sl.related_products[0].to_xml.to_s.include?("<RelationCode>01</RelationCode>").should be_true
    sl.related_products[1].to_xml.to_s.include?("<RelationCode>02</RelationCode>").should be_true
  end
  
  specify "should provide read access to replacement" do
    @product  = ONIX::Product.from_xml(@product_node.to_s)
    @sl       = ONIX::SLProduct.new(@product)

    @sl.replacement.relation_code.should eql(5)
    @sl.replacement.proprietary_id.should eql("123456")
  end
  
  specify "should provide write access to replacement" do
    sl = ONIX::SLProduct.new
    
    sl.replacement = "XYZ123"
    sl.related_products[0].to_xml.to_s.include?("<RelationCode>05</RelationCode>").should be_true
    sl.related_products[0].to_xml.to_s.include?("<ProductIDType>01</ProductIDType>").should be_true
    sl.related_products[0].to_xml.to_s.include?("<IDValue>XYZ123</IDValue>").should be_true
  end

end

context ONIX::SLProduct, "series method" do
  specify "should set the nested series value on the underlying product class" do
    sl = ONIX::SLProduct.new

    sl.series = "Harry Potter"
    sl.series = "Lemony Snicket"
    sl.to_xml.to_s.include?("<TitleOfSeries>Harry Potter</TitleOfSeries>").should be_true
    sl.to_xml.to_s.include?("<TitleOfSeries>Lemony Snicket</TitleOfSeries>").should be_true
  end
end

context ONIX::SLProduct, "price method" do
  before(:each) do
    @data_path = File.join(File.dirname(__FILE__),"..","data")
    file1    = File.join(@data_path, "usd.xml")
    @doc     = Nokogiri::XML::Document.parse(File.read(file1))
    @product_node = @doc.root
  end

  specify "should return the first price in the file, regardless of type" do
    @product = ONIX::Product.from_xml(@product_node.to_s)
    @sl     = ONIX::SLProduct.new(@product)

    @sl.price.should eql(BigDecimal.new("99.95"))
  end
end

context ONIX::SLProduct, "rrp_exc_sales_tax method" do
  before(:each) do
    @data_path = File.join(File.dirname(__FILE__),"..","data")
    file1    = File.join(@data_path, "usd.xml")
    @doc     = Nokogiri::XML::Document.parse(File.read(file1))
    @product_node = @doc.root
  end

  specify "should return the first price in the file of type 1" do
    @product = ONIX::Product.from_xml(@product_node.to_s)
    @sl     = ONIX::SLProduct.new(@product)

    @sl.rrp_exc_sales_tax.should eql(BigDecimal.new("99.95"))
  end
end
