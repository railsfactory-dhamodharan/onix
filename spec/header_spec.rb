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

    product.from_company.should eql("Text Company")
    product.from_email.should eql("james@rainbowbooks.com.au")
    product.from_person.should eql("James")
    product.message_note.should eql("A Message")
    product.sent_date.should eql("20080519")
  end
end
