# coding: utf-8

require 'spec_helper.rb'

describe ONIX::ProductClassification do

  before(:each) do
    load_doc_and_root("product_classification.xml")
  end

  it "should correctly convert to a string" do
    a = ONIX::ProductClassification.from_xml(@root.to_s)
    tag = "<ProductClassification>"
    a.to_xml.to_s[0, tag.length].should eql(tag)
  end

  it "should provide read access to first level attributes" do
    a = ONIX::ProductClassification.from_xml(@root.to_s)
    a.product_classification_type.should eql(2)
    a.product_classification_code.should eql("55101514")
    a.percent.should eql(66.67)
  end

  it "should provide write access to first level attributes" do
    a = ONIX::ProductClassification.new

    a.product_classification_type = 3
    a.to_xml.to_s.include?("<ProductClassificationType>03</ProductClassificationType>").should be_true

    a.product_classification_code = "DATA"
    a.to_xml.to_s.include?("<ProductClassificationCode>DATA</ProductClassificationCode>").should be_true

    a.percent = 50
    a.to_xml.to_s.include?("<Percent>50</Percent>").should be_true
  end

end
