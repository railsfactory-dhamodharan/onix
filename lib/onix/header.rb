module ONIX
  class Header < Base
    def initialize(node = nil)
      if node.kind_of? XML::Node
        @root_node = node
      else
        @root_node = XML::Node.new("Header")
      end 
    end

    def from_ean_number
      text_content '//Header/FromEANNumber'
    end

    def from_san
      text_content '//Header/FromSAN'
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

    def message_repeat
      numeric_content '//Header/MessageRepeat'
    end

    def sent_date
      text_content '//Header/SentDate'
    end

    def to_ean_number
      text_content '//Header/ToEANNumber'
    end

    def to_san
      text_content '//Header/ToSAN'
    end

    def to_company
      text_content '//Header/ToCompany'
    end

    def to_person
      text_content '//Header/ToPerson'
    end

    def default_language_of_text
      text_content '//Header/DefaultLanguageOfText'
    end

    def default_price_type_code
      numeric_content '//Header/DefaultPriceTypeCode'
    end

    def default_currency_code
      text_content '//Header/DefaultCurrencyCode'
    end

    def default_linear_unit
      text_content '//Header/DefaultLinearUnit'
    end

    def default_weight_unit
      text_content '//Header/DefaultWeightUnit'
    end

    def default_class_of_trade
      text_content '//Header/DefaultClassOfTrade'
    end
  end
end
