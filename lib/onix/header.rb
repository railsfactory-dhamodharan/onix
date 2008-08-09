module ONIX

  # A mega class that wraps an ONIX <Header> record - one per ONIXMessage.
  # 
  # See ONIX::Reader and ONIX::Writer for examples of using this class.
  class Header < Base
    def initialize(node = nil)
      if node.kind_of? XML::Node
        @root_node = node
      else
        @root_node = XML::Node.new("Header")
      end 
    end

    def from_ean_number
      text_content '/FromEANNumber'
    end

    def from_san
      text_content '/FromSAN'
    end

    def from_company
      text_content '/FromCompany'
    end

    def from_email
      text_content '/FromEmail'
    end

    def from_person
      text_content '/FromPerson'
    end

    def message_note
      text_content '/MessageNote'
    end

    def message_repeat
      numeric_content '/MessageRepeat'
    end

    def sent_date
      date_content '/SentDate'
    end

    def to_ean_number
      text_content '/ToEANNumber'
    end

    def to_san
      text_content '/ToSAN'
    end

    def to_company
      text_content '/ToCompany'
    end

    def to_person
      text_content '/ToPerson'
    end

    def default_language_of_text
      text_content '/DefaultLanguageOfText'
    end

    def default_price_type_code
      numeric_content '/DefaultPriceTypeCode'
    end

    def default_currency_code
      text_content '/DefaultCurrencyCode'
    end

    def default_linear_unit
      text_content '/DefaultLinearUnit'
    end

    def default_weight_unit
      text_content '/DefaultWeightUnit'
    end

    def default_class_of_trade
      text_content '/DefaultClassOfTrade'
    end
  end
end
