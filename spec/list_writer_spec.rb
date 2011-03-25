# coding: utf-8

require File.dirname(__FILE__) + '/spec_helper.rb'

describe ONIX::ListWriter do
  
  module ONIX
    class FakeEntity
      include ROXML
      extend ONIX::ListWriter
      
      xml_name "FakeEntity"
      xml_reader :series_id_type, :from => "SeriesIDType", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
      list_writer :series_id_type, :list => 13
      
      def initialize(options = {})
        self.series_id_type = options[:series_id_type]
      end
    end
  end
  
  before :each do
    data_path = File.join(File.dirname(__FILE__),"..","data")
    file1 = File.join(data_path, "fake_entity_for_lists.xml")
    @doc = Nokogiri::XML::Document.parse(File.read(file1))
    @root = @doc.root
  end
  
  it "should provide read access to first level attribute" do
    fake = ONIX::FakeEntity.from_xml(@root.to_s)
    fake.series_id_type.should eql(1)
  end
  
  it "should provide write access to first level attribute" do
    fake = ONIX::FakeEntity.new(:series_id_type => 3)
    fake.series_id_type.should eql(3)
    fake.to_xml.to_s.include?("<SeriesIDType>03</SeriesIDType>").should be_true
  end
  
  it "should raise error writing value not in list" do
    fake = ONIX::FakeEntity.new
    lambda {fake.series_id_type = 100}.should raise_error
    lambda {ONIX::FakeEntity.new(:series_id_type => 100)}.should raise_error
  end

end
