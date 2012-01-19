# coding: utf-8

require File.dirname(__FILE__) + '/spec_helper.rb'

describe ONIX::Complexity do

  before(:each) do
    data_path = File.join(File.dirname(__FILE__), "..", "data")
    file1     = File.join(data_path, "complexity.xml")
    @doc      = Nokogiri::XML::Document.parse(File.read(file1))
    @root     = @doc.root
  end

  it "should correctly convert to a string" do
    t = ONIX::Complexity.from_xml(@root.to_s)
    t.to_xml.to_s[0,12].should eql("<Complexity>")
  end

  it "should provide read access to first level attributes" do
    t = ONIX::Complexity.from_xml(@root.to_s)
    t.complexity_scheme_identifier.should eql(2)
    t.complexity_code.should eql("640")
  end

  it "should provide write access to first level attributes" do
    t = ONIX::Complexity.new

    t.complexity_scheme_identifier = 1
    t.to_xml.to_s.include?("<ComplexitySchemeIdentifier>01</ComplexitySchemeIdentifier>").should be_true

    t.complexity_code = "480"
    t.to_xml.to_s.include?("<ComplexityCode>480</ComplexityCode>").should be_true
  end
  
  it "should raise error writing complexity_scheme_identifier value not in list" do
    t = ONIX::Complexity.new
    lambda {t.complexity_scheme_identifier = 999}.should raise_error
    lambda {ONIX::Complexity.new(:complexity_scheme_identifier => 999)}.should raise_error
  end
  
  it "should properly initialize attributes when calling new" do
    t = ONIX::Complexity.new(:complexity_scheme_identifier => 1, :complexity_code => "value")
    t.complexity_scheme_identifier.should eql(1)
    t.complexity_code.should eql("value")
  end

end
