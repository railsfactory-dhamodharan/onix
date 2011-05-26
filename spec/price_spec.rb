# coding: utf-8

require File.dirname(__FILE__) + '/spec_helper.rb'

describe ONIX::Price do

  before(:each) do
    data_path = File.join(File.dirname(__FILE__),"..","data")
    file1     = File.join(data_path, "price.xml")
    @doc      = Nokogiri::XML::Document.parse(File.read(file1))
    @root     = @doc.root
  end

  it "should correctly convert to a string" do
    p = ONIX::Price.from_xml(@root.to_s)
    p.to_xml.to_s[0,7].should eql("<Price>")
  end

  it "should provide read access to first level attributes" do
    p = ONIX::Price.from_xml(@root.to_s)

    p.price_type_code.should eql(2)
    p.discount_percent.should eql(BigDecimal.new("45"))
    p.price_amount.should eql(BigDecimal.new("7.5"))
    p.price_effective_from.should eql("19990101")
    p.price_effective_until.should eql("20001231")
  end

  it "should provide read access to discount_codeds" do
    p = ONIX::Price.from_xml(@root.to_s)

    d = p.find_discount_coded(1)
    d.discount_code_type_name.should eql("britishco")
    d.discount_code.should eql("999ZZZ")

    d = p.find_discount_coded(:discount_code_type_name => 'bakertaylor')
    d.discount_code_type.should eql(2)
    d.discount_code_type_name.should eql("bakertaylor")
    d.discount_code.should eql("ABC123")

    d = p.find_discount_coded(:proprietary) # will retrieve first proprietary discount code
    d.discount_code_type_name.should eql("ingram")
    d.discount_code.should eql("XYZ987")
  end

  it "should provide write access to first level attributes" do
    p = ONIX::Price.new

    p.price_type_code = 1
    p.to_xml.to_s.include?("<PriceTypeCode>01</PriceTypeCode>").should be_true

    p.discount_percent = BigDecimal.new("50")
    p.to_xml.to_s.include?("<DiscountPercent>50.0</DiscountPercent>").should be_true

    p.price_amount = BigDecimal.new("7.5")
    p.to_xml.to_s.include?("<PriceAmount>7.5</PriceAmount>").should be_true

    p.price_effective_from = Date.civil(1999,1,1)
    p.to_xml.to_s.include?("<PriceEffectiveFrom>19990101</PriceEffectiveFrom>").should be_true

    p.price_effective_until = Date.civil(2000,12,31)
    p.to_xml.to_s.include?("<PriceEffectiveUntil>20001231</PriceEffectiveUntil>").should be_true
  end

  it "should provide write access to discount_codeds" do
    d1 = ONIX::DiscountCoded.new(:discount_code_type => 1, :discount_code => "value1", :discount_code_type_name => "name1")
    d2 = ONIX::DiscountCoded.new(:discount_code_type => 2, :discount_code => "value2", :discount_code_type_name => "name2")
    d3 = ONIX::DiscountCoded.new(:discount_code_type => 3, :discount_code => "value3", :discount_code_type_name => "name3")
    # p = ONIX::Price.new(:discount_codeds => [d1,d2])
    p = ONIX::Price.new
    p.discount_codeds = [d1, d2]
    p.discount_codeds << d3
    p.discount_codeds.size.should eql(3)
    (1..p.discount_codeds.size).to_a.each do |i|
      name = "name#{i}"
      value = "value#{i}"
      t = p.find_discount_coded(:discount_code_type_name => name)
      t.discount_code_type.should eql(i)
      t.discount_code.should eql(value)
      t.discount_code_type_name.should eql(name)
    end
  end

end

