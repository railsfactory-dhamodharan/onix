# coding: utf-8

require 'spec_helper.rb'

describe ONIX::ProductWebsite do

  before(:each) do
    load_doc_and_root("product_website.xml")
  end

  it "should correctly convert to a string" do
    web = ONIX::ProductWebsite.from_xml(@root.to_s)
    web.to_xml.to_s[0,16].should eql("<ProductWebsite>")
  end

  it "should provide read access to first level attributes" do
    web = ONIX::ProductWebsite.from_xml(@root.to_s)
    web.website_role.should eql(1)
    web.product_website_description.should eql("The Child's World: Publishing books for schools and libraries since 1968")
    web.product_website_link.should eql("http://childsworld.com")
  end

  it "should provide write access to first level attributes" do
    web = ONIX::ProductWebsite.new

    web.website_role = 2
    web.to_xml.to_s.include?("<WebsiteRole>02</WebsiteRole>").should be_true

    web.product_website_link = "PUBLISHER WEBSITE"
    web.to_xml.to_s.include?("<ProductWebsiteLink>PUBLISHER WEBSITE</ProductWebsiteLink>").should be_true

    web.product_website_link = "http://www.randomhouse.com"
    web.to_xml.to_s.include?("<ProductWebsiteLink>http://www.randomhouse.com</ProductWebsiteLink>").should be_true
  end

end

