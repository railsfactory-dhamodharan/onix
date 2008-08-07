require 'rexml/document'

module ONIX
  class Writer

    DOCTYPE = "<!DOCTYPE ONIXMessage SYSTEM \"http://www.editeur.org/onix/2.1/03/reference/onix-international.dtd\">"

    def initialize(output, header)
      raise ArgumentError, 'msg must be an ONIX::Header object' unless header.kind_of?(ONIX::Header)
      @output = output
      @header = header

      start_document
    end

    def self.open(output, header, &block)
      writer = self.new(output, header)
      yield writer
      writer.end_document
    end

    def << (product)
      unless product.kind_of?(ONIX::Product)
        raise ArgumentError, 'product must be an ONIX::Product'
      end
      @output.write(product.to_s + "\n")
    end

    def end_document
      @output.write("</ONIXMessage>\n")
    end

    private

    def start_document
      decl = REXML::XMLDecl.new
      doctype = REXML::DocType.new('ONIXMessage', "SYSTEM \"#{DOCTYPE}\"")
      decl.encoding = "utf-8"
      @output.write(decl.to_s+"\n")
      @output.write(doctype.to_s+"\n")
      @output.write("<ONIXMessage>\n")
      @output.write(@header.to_s + "\n")
    end

  end
end
