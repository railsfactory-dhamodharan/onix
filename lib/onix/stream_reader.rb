require 'thread'
require 'timeout'
require 'stringio'

module ONIX
  # Used to process an ONIX file and extract the data
  #
  #   reader = ONIX::Reader.new("somefile.xml")
  #   puts "From: #{header.from_person}"
  #   puts "From: #{header.from_company}"
  #
  #   reader.each do |product|
  #     puts product.id(:ean)
  #   end
  #
  class StreamReader

    attr_reader :header, :version, :xml_lang, :xml_version, :encoding
    
    def initialize(input, product_klass = ::ONIX::Product)
      if input.kind_of? String
        @reader = LibXML::XML::Reader.file(input)
      elsif input.kind_of?(IO)
        @reader = LibXML::XML::Reader.io(input)
      else
        throw "Unable to read from path or file"
      end

      @product_klass = product_klass

      # create a sized queue to store each product read from the file
      @queue = SizedQueue.new(100)

      # launch a reader thread to process the file and store each
      # product in the queue
      Thread.abort_on_exception = true
      Thread.new { read_input }
    end

    def each(&block)
      obj = @queue.pop
      while !obj.nil?
        yield obj
        obj = @queue.pop
      end
    end

    private

    def read_input
      while @reader.read == 1
        @xml_lang    = @reader.xml_lang         if @xml_lang.nil?
        @xml_version = @reader.xml_version.to_f if @xml_version.nil?
        @encoding    = @reader.encoding         if @encoding.nil?
        if @reader.node_type == 10
          uri = @reader.expand.to_s
          m, major, minor, rev = *uri.match(/.+(\d)\.(\d)\/(\d*).*/)
          @version = [major.to_i, minor.to_i, rev.to_i]
        elsif @reader.name == "Header" && @reader.node_type == 1
          node = @reader.expand
          element = REXML::Document.new(node.to_s).root
          @header = ONIX::Header.load_from_xml(element)
          @reader.next_sibling
        elsif @reader.name == "Product" && @reader.node_type == 1
          node = @reader.expand
          element = REXML::Document.new(node.to_s).root
          product = @product_klass.load_from_xml(element)
          @queue.push product
          @reader.next_sibling
        end
      end
      @queue.push nil
    end
  end
end
