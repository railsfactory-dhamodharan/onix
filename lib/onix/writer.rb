module ONIX
  class Writer

    # Default constructor.
    def initialize(output, header)
      raise ArgumentError, 'msg must be an ONIX::Header object' unless header.kind_of?(ONIX::Header)
      @output = output
      @header = header

      start_document
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
      doctype = REXML::DocType.new('ONIXMessage', "SYSTEM \"#{ONIX::Message::ONIX_DTD_URL}\"")
      decl.encoding = "utf-8"
      @output.write(decl.to_s+"\n")
      @output.write(doctype.to_s+"\n")
      @output.write("<ONIXMessage>\n")
      @formatter.write(@header.save_to_xml, @output)
    end

  end
end
