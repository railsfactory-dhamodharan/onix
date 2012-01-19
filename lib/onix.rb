# coding: utf-8

require 'bigdecimal'
require 'cgi'
require 'singleton'
require 'roxml'

module ONIX
  class Formatters
    def self.decimal
      lambda do |val|
        if val.nil?
          nil
        elsif val.kind_of?(BigDecimal)
          val.to_s("F")
        else
          val.to_s
        end
      end
    end

    def self.yyyymmdd
      lambda do |val|
        if val.nil? || !val.respond_to?(:strftime)
          nil
        else
          val.strftime("%Y%m%d")
        end
      end
    end

    def self.two_digit
      padded_number(2)
    end
    
    def self.three_digit
      padded_number(3)
    end
    
    def self.padded_number(n)
      lambda do |val|
        if val.nil?
          nil
        elsif val >= 0 && val < 10**n
          sprintf("%0#{n}d", val)
        else
          raise ArgumentError, "Value '#{val}' does not conform to #{n}-digit restrictions"
        end
      end
    end

    def self.space_separated
      lambda { |val| val.join(" ")  if val }
    end
  end
end

# helper modules
require "onix/list_writer"
require "onix/inflector"
require "onix/product_identifiers"
require "onix/work_identifiers"
require "onix/discount_codeds"

# core files
# - ordering is important, classes need to be defined before any
#   other class can use them
require "onix/sender_identifier"
require "onix/addressee_identifier"
require "onix/header"
require "onix/product_identifier"
require "onix/series_identifier"
require "onix/series"
require "onix/set"
require "onix/title"
require "onix/work_identifier"
require "onix/website"
require "onix/contributor"
require "onix/language"
require "onix/subject"
require "onix/audience_range"
require "onix/complexity"
require "onix/imprint"
require "onix/publisher"
require "onix/other_text"
require "onix/media_file"
require "onix/sales_restriction"
require "onix/sales_rights"
require "onix/not_for_sale"
require "onix/stock"
require "onix/discount_coded"
require "onix/price"
require "onix/related_product"
require "onix/supply_detail"
require "onix/market_representation"
require "onix/measure"
require "onix/product"
require "onix/reader"
require "onix/writer"

# product wrappers
require "onix/simple_product"
require "onix/apa_product"
require "onix/sl_product"

# misc
require "onix/lists"
require "onix/normaliser"
require "onix/code_list_extractor"
