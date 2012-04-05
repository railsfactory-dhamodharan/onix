# coding: utf-8

class ONIX::ContainedItem < ONIX::Element
  xml_name "ContainedItem"
  onix_composite :product_identifiers, ONIX::ProductIdentifier
  onix_code_from_list :product_form, "ProductForm", :list => 7
  onix_codes_from_list :product_form_details, "ProductFormDetail", :list => 78
  onix_composite :product_form_features, ONIX::ProductFormFeature
  onix_code_from_list :product_packaging, "ProductPackaging", :list => 80
  xml_accessor :product_form_description, :from => "ProductFormDescription"
  xml_accessor :number_of_pieces, :from => "NumberOfPieces", :as => Fixnum
  onix_code_from_list :trade_category, "TradeCategory", :list => 12
  onix_code_from_list :product_content_type, "ProductContentType", :list => 81
  xml_accessor :item_quantity, :from => "ItemQuantity", :as => Fixnum
end
