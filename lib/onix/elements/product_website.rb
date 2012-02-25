# coding: utf-8

class ONIX::ProductWebsite < ONIX::Element
  xml_name "ProductWebsite"
  onix_code_from_list :website_role, "WebsiteRole", :list => 73
  xml_accessor :product_website_description, :from => "ProductWebsiteDescription"
  xml_accessor :product_website_link, :from => "ProductWebsiteLink"
end
