# coding: utf-8

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')

require 'onix'

context "ONIX::Header" do

  before(:each) do
    data_path = File.join(File.dirname(__FILE__),"..","data")
    file1    = File.join(data_path, "header.xml")
    @doc = XML::Document.file(file1)
    @header_node = @doc.root
  end

  specify "should initialise with an existing node" do
    product = ONIX::Header.new(@header_node)
    product.instance_variable_get("@root_node").should eql(@header_node)
  end

  specify "should create an empty node if none is provided on init" do
    product = ONIX::Header.new
    product.instance_variable_get("@root_node").should be_a_kind_of(XML::Node)
  end

  specify "should provide read access to first level attibutes" do
    product = ONIX::Header.new(@header_node)

    product.from_ean_number.should eql("1111111111111")
    product.from_san.should eql("1111111")
    product.from_company.should eql("Text Company")
    product.from_email.should eql("james@rainbowbooks.com.au")
    product.from_person.should eql("James")

    product.to_ean_number.should eql("2222222222222")
    product.to_san.should eql("2222222")
    product.to_company.should eql("Company 2")
    product.to_person.should eql("Chris")

    product.message_note.should eql("A Message")
    product.message_repeat.should eql(1)
    product.sent_date.should eql("20080519")

    product.default_language_of_text.should eql("aaa")
    product.default_price_type_code.should eql(1)
    product.default_currency_code.should eql("ccc")
    product.default_linear_unit.should eql("dd")
    product.default_weight_unit.should eql("ee")
    product.default_class_of_trade.should eql("f")
  end
end
