# coding: utf-8

require File.dirname(__FILE__) + '/spec_helper.rb'

describe ONIX::WorkIdentifiers do
  
  module ONIX
    class FakeWorkEntity
      include ROXML
      include ONIX::WorkIdentifiers
      
      xml_name "FakeWorkEntity"
      xml_reader :work_identifiers, :from => "WorkIdentifier", :as => [ONIX::WorkIdentifier]
      
      def initialize(options = {})
        initialize_work_identifiers(options) # @work_identifiers array
      end
    end
  end
  
  before :each do
    @fake1 = ONIX::FakeWorkEntity.new(:isbn => 123456)
    data_path = File.join(File.dirname(__FILE__),"..","data")
    file1 = File.join(data_path, "fake_entity.xml")
    @doc = Nokogiri::XML::Document.parse(File.read(file1))
    @root = @doc.root
  end
  
  it "should instantiate work identifiers array" do
    @fake1.work_identifiers.should be_a(Array)
  end
  
  it "should provide read access to work identifiers" do
    fe = ONIX::FakeWorkEntity.from_xml(@root.to_s)
    wid = fe.find_work_identifier(1)
    wid.id_value.should eql("WD_PROPRIETARY_ID")
    wid = fe.find_work_identifier(:proprietary_id)
    wid.id_value.should eql("WD_PROPRIETARY_ID")
    wid = fe.find_work_identifier(:isbn10)
    wid.id_value.should eql("WD_ISBN10")
    wid = fe.find_work_identifier(:isbn13)
    wid.id_value.should eql("WD_ISBN13")
    wid = fe.find_work_identifier(:isbn)
    wid.id_value.should eql("WD_ISBN13")
  end

  it "should provide write access to work identifiers by work_id_type" do
    id_value = "123456"
    {:proprietary_id => 1, :isbn10 => 2, :isbn13 => 15, :isbn => 15}.each do |key, work_id_type|
      fe = ONIX::FakeWorkEntity.new
      fe.set_work_identifier(work_id_type, id_value)
      fe.to_xml.to_s.include?("<WorkIDType>#{sprintf('%02d', work_id_type)}</WorkIDType>").should be_true
      fe.to_xml.to_s.include?("<IDValue>#{id_value}</IDValue>").should be_true
    end
  end
  
  it "should provide write access to work identifiers by key" do
    id_value = "123456"
    {:proprietary_id => 1, :isbn10 => 2, :isbn13 => 15, :isbn => 15}.each do |key, work_id_type|
      fe = ONIX::FakeWorkEntity.new
      fe.set_work_identifier(key, id_value)
      fe.to_xml.to_s.include?("<WorkIDType>#{sprintf('%02d', work_id_type)}</WorkIDType>").should be_true
      fe.to_xml.to_s.include?("<IDValue>#{id_value}</IDValue>").should be_true
    end
  end
  
  it "should fail to write work identifier with invalid work_id_type" do
    id_value = "123456"
    work_id_type = 99
    fe = ONIX::FakeWorkEntity.new
    lambda {fe.set_work_identifier(work_id_type, id_value)}.should raise_error(ArgumentError)
  end
  
  it "should fail to write work identifier with invalid key" do
    id_value = "123456"
    key = "bad_key"
    fe = ONIX::FakeWorkEntity.new
    lambda {fe.set_work_identifier(key, id_value)}.should raise_error(ArgumentError)
  end
  
  it "should provide write access to work_identifiers array" do
    id = ONIX::WorkIdentifier.new
    id.work_id_type = 1
    id.id_value = "123456"
    fe = ONIX::FakeWorkEntity.new(:work_identifiers => id)
  
    fe.to_xml.to_s.include?("<WorkIdentifier>").should be_true
    fe.to_xml.to_s.include?("<WorkIDType>01</WorkIDType>").should be_true
    fe.to_xml.to_s.include?("<IDValue>123456</IDValue>").should be_true
  
    id = ONIX::WorkIdentifier.new
    id.work_id_type = 2
    id.id_value = "987654"
    fe.work_identifiers << id
  
    fe.to_xml.to_s.include?("<WorkIDType>02</WorkIDType>").should be_true
    fe.to_xml.to_s.include?("<IDValue>987654</IDValue>").should be_true
  end

end
