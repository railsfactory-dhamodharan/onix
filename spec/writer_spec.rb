# coding: utf-8

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')

require 'onix'
require 'stringio'

context "ONIX::Writer" do

  before(:each) do
    @output = StringIO.new
  end

  specify "should output the correct xml metadata" do
    header = ONIX::Header.new
    writer = ONIX::Writer.new(@output, header)
    writer.end_document

    lines = @output.string.split("\n")

    # xml declaration
    lines[0][0,5].should eql("<?xml")

    # doctype
    lines[1][0,9].should eql("<!DOCTYPE")
  end

  specify "should output the correct xml metadata when used in block form" do
    header = ONIX::Header.new
    ONIX::Writer.open(@output, header) { |writer| }

    lines = @output.string.split("\n")

    # xml declaration
    lines[0][0,5].should eql("<?xml")

    # doctype
    lines[1][0,9].should eql("<!DOCTYPE")
  end

  specify "should output the header node" do
    header = ONIX::Header.new

    ONIX::Writer.open(@output, header) { |writer| }

    lines = @output.string.split("\n")

    lines[3][0,7].should eql("<Header")
  end

  specify "should output the product node" do
    header = ONIX::Header.new
    product = ONIX::Product.new

    ONIX::Writer.open(@output, header) do |writer| 
      writer << product
    end

    lines = @output.string.split("\n")

    lines[4][0,8].should eql("<Product")
  end
end
