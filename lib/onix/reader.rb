require 'thread'
require 'timeout'
require 'stringio'

module ONIX
  class Reader

    attr_reader :header
    
    def initialize(input)
      if input.kind_of? String
        @reader = XML::Reader.file(input)
      elsif input.kind_of?(File) || input.kind_of?(StringIO)
        @reader = XML::Reader.new(input)
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
        if @reader.name == "Header" && @reader.node_type == 1
          @header = ONIX::Header.new(@reader.expand)
          @reader.next_sibling
        elsif @reader.name == "Product" && @reader.node_type == 1
          @queue.push ONIX::Product.new(@reader.expand)
          @reader.next_sibling
        end
      end
      @queue.push nil
    end

    def build_header(str)
      str
    end

    def build_product(str)
    end
  end
end
