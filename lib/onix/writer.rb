require 'rexml/document'

module ONIX
  class Writer

    DOCTYPE = "http://www.editeur.org/onix/2.1/03/reference/onix-international.dtd"

    def initialize(output, header)
      raise ArgumentError, 'msg must be an ONIX::Header object' unless header.kind_of?(ONIX::Header)
      @output = output
      @header = header
      @finished = false

      start_document
    end

    def self.open(output, header, &block)
      writer = self.new(output, header)
      yield writer
      writer.finish
    end

    def << (product)
      unless product.kind_of?(ONIX::Product)
        raise ArgumentError, 'product must be an ONIX::Product'
      end
      raise "Can't add another product. Writer has been finished." if finished?
      @output.write(add_character_references(product.to_s) + "\n")
    end

    def finish
      @output.write("</ONIXMessage>\n")
      @finished = true
    end

    def finished?
      @finished
    end

    private

    def start_document
      decl = REXML::XMLDecl.new
      doctype = REXML::DocType.new('ONIXMessage', "SYSTEM \"#{DOCTYPE}\"")
      decl.encoding = "utf-8"
      @output.write(decl.to_s+"\n")
      @output.write(doctype.to_s+"\n")
      @output.write("<ONIXMessage>\n")
      @output.write(add_character_references(@header.to_s) + "\n")
    end

    # convert all non ASCII characters to a character reference. Leave &
    # and < alone, libxml handles converting them to entity references.
    #
    # http://en.wikipedia.org/wiki/XML#Numeric_character_references
    #
    def add_character_references(str)
      str.unpack("U*").collect do |c|
        if c <= 127
          c.chr
        else
          "&##{c};"
        end
      end.join
    end

  end
end
