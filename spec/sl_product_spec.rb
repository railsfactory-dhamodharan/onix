# coding: utf-8

require File.dirname(__FILE__) + '/spec_helper.rb'
require 'date'

context "ONIX::SLProduct" do

  before(:each) do
    @data_path = File.join(File.dirname(__FILE__),"..","data")
    file1    = File.join(@data_path, "product.xml")
    @doc     = Nokogiri::XML::Document.parse(File.read(file1))
    @product_node = @doc.root
  end

  specify "should provide read access to attributes" do
    @product = ONIX::Product.from_xml(@product_node.to_s)
    @sl     = ONIX::SLProduct.new(@product)

    @sl.record_reference.should eql("365-9780194351898")
    @sl.notification_type.should eql(3)
    @sl.product_form.should eql("BC")
    @sl.number_of_pages.should eql(100)
    @sl.bic_main_subject.should eql("EB")
    @sl.publishing_status.should eql(4)
    @sl.publication_date.should eql(Date.civil(1998,9,1))
    @sl.pack_quantity.should eql(12)
  end

  specify "should provide write access to attributes" do
    sl = ONIX::SLProduct.new

    sl.notification_type = 3
    sl.to_xml.to_s.include?("<NotificationType>03</NotificationType>").should be_true

    sl.record_reference = "365-9780194351898"
    sl.to_xml.to_s.include?("<RecordReference>365-9780194351898</RecordReference>").should be_true

    sl.product_form = "BC"
    sl.to_xml.to_s.include?("<ProductForm>BC</ProductForm>").should be_true

    sl.number_of_pages = 100
    sl.to_xml.to_s.include?("<NumberOfPages>100</NumberOfPages>").should be_true

    sl.bic_main_subject = "EB"
    sl.to_xml.to_s.include?("<BICMainSubject>EB</BICMainSubject>").should be_true

    sl.publishing_status = 4
    sl.to_xml.to_s.include?("<PublishingStatus>04</PublishingStatus>").should be_true

    sl.publication_date = Date.civil(1998,9,1)
    sl.to_xml.to_s.include?("<PublicationDate>19980901</PublicationDate>").should be_true

    sl.pack_quantity = 12
    sl.to_xml.to_s.include?("<PackQuantity>12</PackQuantity>").should be_true
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
