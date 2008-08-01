module ONIX
  class Header < Base
    def initialize(node = nil)
      if node.kind_of? XML::Node
        @node = node
      else
        @node = XML::Node.new
      end 
    end

    def from_company
      text_content '//Header/FromCompany'
    end

    def from_email
      text_content '//Header/FromEmail'
    end

    def from_person
      text_content '//Header/FromPerson'
    end

    def message_note
      text_content '//Header/MessageNote'
    end

    def sent_date
      text_content '//Header/SentDate'
    end

    def to_company
      text_content '//Header/ToCompany'
    end

    def to_person
      text_content '//Header/ToPerson'
    end

    private

    def text_content(path)
      n = @node.find_first(path)
      n ? n.content : nil
    end
  end
end
