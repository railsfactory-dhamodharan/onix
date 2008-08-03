# coding: utf-8

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')

require 'onix'

context "ONIX::Product" do

  before(:each) do
    data_path = File.join(File.dirname(__FILE__),"..","data")
    file1    = File.join(data_path, "product.xml")
    @doc = XML::Document.file(file1)
    @product_node = @doc.root
  end

  specify "should initialise with an existing node" do
    product = ONIX::Product.new(@product_node)
    product.instance_variable_get("@root_node").should eql(@product_node)
  end

  specify "should create an empty node if none is provided on init" do
    product = ONIX::Product.new
    product.instance_variable_get("@root_node").should be_a_kind_of(XML::Node)
  end

  specify "should provide read access to first level attibutes" do
    product = ONIX::Product.new(@product_node)

    product.record_reference.should eql("365-9780194351898")
    product.notification_type.should eql(3)
    product.product_form.should eql("BC")
  end

  specify "should provide read access to product IDs" do
    product = ONIX::Product.new(@product_node)

    product.isbn10.should eql("0194351890")
    product.isbn13.should eql("9780194351898")
    product.ean.should eql("9780194351898")
  end

end
