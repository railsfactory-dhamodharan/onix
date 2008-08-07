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
  class Reader

    attr_reader :header, :version, :xml_lang, :xml_version, :encoding
    
    def initialize(input)
      if input.kind_of? String
        @reader = XML::Reader.file(input)
      elsif input.kind_of?(IO)
        # TODO: this isn't very scalable. Can I get XML::Reader
        #       to read from the IO object as it goes?
        @reader = XML::Reader.io(input)
      else
        throw "Unable to read from path or file"
      end
      
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
          @header = ONIX::Header.new(@reader.expand)
          @reader.next_sibling
        elsif @reader.name == "Product" && @reader.node_type == 1
          @queue.push ONIX::Product.new(@reader.expand)
          @reader.next_sibling
        end
      end
      @queue.push nil
    end
  end
end
