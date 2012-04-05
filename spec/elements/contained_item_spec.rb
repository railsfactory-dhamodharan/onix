# coding: utf-8

require 'spec_helper.rb'

describe ONIX::ContainedItem do

  before(:each) do
    load_doc_and_root("contained_item.xml")
  end

  it "should correctly convert to a string" do
    item = ONIX::ContainedItem.from_xml(@root.to_s)
    item.to_xml.to_s[0,15].should eql("<ContainedItem>")
  end

  it "should provide read access to first level attributes" do
    item = ONIX::ContainedItem.from_xml(@root.to_s)
    item.product_form.should eql("BB")
    item.product_form_details.should eql(["B206"])
    item.item_quantity.should eql(1)
  end

  it "should provide write access to first level attributes" do
    item = ONIX::ContainedItem.new
    item.product_content_type = 1
    item.to_xml.to_s.include?("<ProductContentType>01</ProductContentType>").should be_true
  end

  it "should provide read access to product identifiers" do
    item = ONIX::ContainedItem.from_xml(@root.to_s)
    item.product_identifiers.first.id_value.should eql("9999")
    item.product_identifiers.last.id_value.should eql("9780194351898")
  end

  it "should provide write access to product identifiers" do
    item = ONIX::ContainedItem.new
    pid = ONIX::ProductIdentifier.new
    lambda { item.product_identifiers << pid }.should change(item.product_identifiers, :size).by(1)
  end

end
