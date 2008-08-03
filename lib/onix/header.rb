module ONIX
  class Header < Base
    def initialize(node = nil)
      if node.kind_of? XML::Node
        @root_node = node
      else
        @root_node = XML::Node.new("Header")
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

  end
end
