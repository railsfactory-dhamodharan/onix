# coding: utf-8

require 'spec_helper.rb'

describe ONIX::Set do

  before(:each) do
    load_doc_and_root("set.xml")
  end

  it "should correctly convert to a string" do
    set = ONIX::Set.from_xml(@root.to_s)
    set.to_xml.to_s[0,5].should eql("<Set>")
  end

  it "should provide read access to first level attributes" do
    set = ONIX::Set.from_xml(@root.to_s)
    set.title_of_set.should eql("THE SET NAME")
  end

  it "should provide write access to first level attributes" do
    set = ONIX::Set.new
    set.title_of_set = "TESTING"
    set.to_xml.to_s.include?("<TitleOfSet>TESTING</TitleOfSet>").should be_true
  end

  it "should provide read access to product identifiers" do
    set = ONIX::Set.from_xml(@root.to_s)
    set.product_identifiers.first.id_value.should eql("9999")
    set.product_identifiers.last.id_value.should eql("9780194351898")
  end

  it "should provide write access to product identifiers" do
    set = ONIX::Set.new
    pid = ONIX::ProductIdentifier.new
    lambda { set.product_identifiers << pid }.should change(set.product_identifiers, :size).by(1)
  end

end
