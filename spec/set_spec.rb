# coding: utf-8

require File.dirname(__FILE__) + '/spec_helper.rb'

context "ONIX::Set" do

  before(:each) do
    data_path = File.join(File.dirname(__FILE__),"..","data")
    file1    = File.join(data_path, "set.xml")
    @doc = Nokogiri::XML::Document.parse(File.read(file1))
    @root = @doc.root
  end

  specify "should correctly convert to a string" do
    set = ONIX::Set.from_xml(@root.to_s)
    set.to_xml.to_s[0,5].should eql("<Set>")
  end

  specify "should provide read access to first level attributes" do
    set = ONIX::Set.from_xml(@root.to_s)

    set.title_of_set.should eql("Citizens and Their Governments")
  end

  specify "should provide write access to first level attributes" do
    set = ONIX::Set.new

    set.title_of_set = "Cool Science Careers"
    set.to_xml.to_s.include?("<TitleOfSet>Cool Science Careers</TitleOfSet>").should be_true
  end

end
