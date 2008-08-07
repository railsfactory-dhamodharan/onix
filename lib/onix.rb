require 'rubygems'
gem 'libxml-ruby', '>=0.8.3'
require 'xml'

require File.dirname(__FILE__) + "/onix/base"
require File.dirname(__FILE__) + "/onix/header"
require File.dirname(__FILE__) + "/onix/product"
require File.dirname(__FILE__) + "/onix/reader"

# lists
require File.join(File.dirname(__FILE__), "onix", "lists", "product_form")

module ONIX
  module Version #:nodoc:
    Major = 0
    Minor = 3
    Tiny  = 0

    String = [Major, Minor, Tiny].join('.')
  end
end
