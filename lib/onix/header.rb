module ONIX

  # A mega class that wraps an ONIX <Header> record - one per ONIXMessage.
  # 
  # See ONIX::Reader and ONIX::Writer for examples of using this class.
  class Header < Base
    def initialize(node = nil)
      if node.kind_of? XML::Node
        @root_node = node
      else
        doc = XML::Document.new
        doc.root = XML::Node.new("Header")
        @root_node = doc.root
      end 
    end

    def from_ean_number
      text_content '/FromEANNumber'
    end

    def from_ean_number=(val)
      node = find_or_create('FromEANNumber')
      node.content = val
    end

    def from_san
      text_content '/FromSAN'
    end

    def from_san=(val)
      node = find_or_create('FromSAN')
      node.content = val
    end

    def from_company
      text_content '/FromCompany'
    end

    def from_company=(val)
      node = find_or_create('FromCompany')
      node.content = val
    end

    def from_email
      text_content '/FromEmail'
    end

    def from_email=(val)
      node = find_or_create('FromEmail')
      node.content = val
    end

    def from_person
      text_content '/FromPerson'
    end

    def from_person=(val)
      node = find_or_create('FromPerson')
      node.content = val
    end

    def message_note
      text_content '/MessageNote'
    end

    def message_note=(val)
      node = find_or_create('MessageNote')
      node.content = val
    end

    def message_repeat
      numeric_content '/MessageRepeat'
    end

    def message_repeat=(val)
      node = find_or_create('MessageRepeat')
      node.content = val.to_s
    end

    def sent_date
      date_content '/SentDate'
    end

    def sent_date=(val)
      raise ArgumentError, 'objects passed to sent_date() must respond to strftime' unless val.respond_to?(:strftime)
      node = find_or_create('SentDate')
      node.content = val.strftime("%Y%m%d")
    end

    def to_ean_number
      text_content '/ToEANNumber'
    end

    def to_ean_number=(val)
      node = find_or_create('ToEANNumber')
      node.content = val
    end

    def to_san
      text_content '/ToSAN'
    end

    def to_san=(val)
      node = find_or_create('ToSAN')
      node.content = val
    end

    def to_company
      text_content '/ToCompany'
    end

    def to_company=(val)
      node = find_or_create('ToCompany')
      node.content = val
    end

    def to_person
      text_content '/ToPerson'
    end

    def to_person=(val)
      node = find_or_create('ToPerson')
      node.content = val
    end

    def default_language_of_text
      text_content '/DefaultLanguageOfText'
    end

    def default_language_of_text=(val)
      node = find_or_create('DefaultLanguageOfText')
      node.content = val
    end

    def default_price_type_code
      numeric_content '/DefaultPriceTypeCode'
    end

    def default_price_type_code=(val)
      node = find_or_create('DefaultPriceTypeCode')
      node.content = val.to_s
    end

    def default_currency_code
      text_content '/DefaultCurrencyCode'
    end

    def default_currency_code=(val)
      node = find_or_create('DefaultCurrencyCode')
      node.content = val
    end

    def default_linear_unit
      text_content '/DefaultLinearUnit'
    end

    def default_linear_unit=(val)
      node = find_or_create('DefaultLinearUnit')
      node.content = val
    end

    def default_weight_unit
      text_content '/DefaultWeightUnit'
    end

    def default_weight_unit=(val)
      node = find_or_create('DefaultWeightUnit')
      node.content = val
    end

    def default_class_of_trade
      text_content '/DefaultClassOfTrade'
    end

    def default_class_of_trade=(val)
      node = find_or_create('DefaultClassOfTrade')
      node.content = val
    end
  end
end
