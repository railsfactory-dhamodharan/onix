# coding: utf-8

module ONIX
  class Price
    include ROXML
    include ONIX::DiscountCodeds
    extend ONIX::ListWriter

    xml_name "Price"

    xml_accessor :price_type_code, :from => "PriceTypeCode", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :price_type_qualifier, :from => "PriceQualifier", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :price_type_description, :from => "PriceTypeDescription"
    xml_accessor :price_per, :from => "PricePer", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :minimum_order_qty, :from => "MinimumOrderQuantity", :as => Fixnum
    xml_accessor :class_of_trade, :from => "ClassOfTrade"
    xml_accessor :bic_discount_group_code, :from => "BICDiscountGroupCode"
    xml_reader :discount_codeds, :from => "DiscountCoded", :as => [ONIX::DiscountCoded]
    xml_accessor :discount_percent, :from => "DiscountPercent", :as => BigDecimal, :to_xml => ONIX::Formatters.decimal
    xml_accessor :price_status, :from => "PriceStatus", :as => Fixnum, :to_xml => ONIX::Formatters.two_digit
    xml_accessor :price_amount, :from => "PriceAmount", :as => BigDecimal, :to_xml => ONIX::Formatters.decimal
    xml_accessor :currency_code, :from => "CurrencyCode"
    xml_reader :country_codes, :from => "CountryCode", :as => []
    list_writer :country_codes, :list => 91
    xml_accessor :price_effective_from, :from => "PriceEffectiveFrom", :to_xml => ONIX::Formatters.yyyymmdd
    xml_accessor :price_effective_until, :from => "PriceEffectiveUntil", :to_xml => ONIX::Formatters.yyyymmdd

    def initialize(options = {})
      initialize_discount_codeds(options) # @discount_codeds array
      @country_codes = []
    end
  end
end
