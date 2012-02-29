# coding: utf-8

require 'spec_helper.rb'

describe ONIX::StockQuantityCoded do

  before(:each) do
    load_doc_and_root("stock_quantity_coded.xml")
  end

  it "should correctly convert to a string" do
    x = ONIX::StockQuantityCoded.from_xml(@root.to_s)
    tag = "<StockQuantityCoded>"
    x.to_xml.to_s[0, tag.length].should eql(tag)
  end

  it "should provide read access to first level attributes" do
    x = ONIX::StockQuantityCoded.from_xml(@root.to_s)
    x.stock_quantity_code_type.should eql(1)
    x.stock_quantity_code_type_name.should eql("Ingram")
    x.stock_quantity_code.should eql("LOW")
  end

  it "should provide write access to first level attributes" do
    x = ONIX::StockQuantityCoded.new

    x.stock_quantity_code_type = 2
    x.to_xml.to_s.include?("<StockQuantityCodeType>02</StockQuantityCodeType>").should be_true

    x.stock_quantity_code_type_name = "Follett"
    x.to_xml.to_s.include?("<StockQuantityCodeTypeName>Follett</StockQuantityCodeTypeName>").should be_true

    x.stock_quantity_code = "OUT"
    x.to_xml.to_s.include?("<StockQuantityCode>OUT</StockQuantityCode>").should be_true
  end

end
