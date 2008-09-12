module ONIX
  # A mega class that wraps an ONIX <Product> record.
  #
  # Generally speaking, there are 3 kinds of product attributes exposed via
  # this class.
  #
  # Those that are a single tag below the root node
  #   
  #   <RecordReference> -> product.record_reference
  #   <ProductForm>     -> product.product_form
  #   etc
  #
  # Those that wrap a repeating element under the root node, where each type can
  # only appear once. These usually have a type subtag, so I've used a single
  # method to provide access to all the composites, with an arg that specifies
  # which one.
  #
  #   <ProductIdentifier> -> product.id(:isbn13) 
  #   <Title>             -> product.title
  #
  # Those that wrap a repeating element under the root node, where each type can
  # appear multiple times. These usually have a type subtag, so I've used a
  # single method to provide access to all the composites, with an arg that
  # specifies which one. An *ARRAY* will be returned.
  #
  #   <Subject> -> product.subjects(:isbn13)
  class Product < Base

    attr_reader :node

    def initialize(node = nil)
      if node.kind_of? XML::Node
        @root_node = node
      else
        doc = XML::Document.new
        doc.root = XML::Node.new("Product")
        @root_node = doc.root
      end 
    end

    def record_reference
      text_content '/RecordReference'
    end

    def record_reference=(val)
      node = find_or_create('RecordReference')
      node.content = val
    end

    def notification_type
      numeric_content '/NotificationType'
    end

    def notification_type=(val)
      node = find_or_create('NotificationType')
      node.content = val.to_s
    end

    # return the interesting value of a ProductIdentifier composite
    #
    #   product.id(:isbn10)
    #   product.id(:isbn13)
    #   product.id(:ean)
    def id(type = :ean)
      text_content "/ProductIdentifier/ProductIDType[text()='#{id_sym_to_num(type)}']/../IDValue"
    end

    def set_id(val, type = :ean)

    end

    # return the interesting value of a Subject composite
    #
    #   product.subjects(:bisac_cat)
    #   product.subjects(:bic_subject)
    def subjects(type = :bic_subject)
      text_content_array "/Subject/SubjectSchemeIdentifier[text()='#{subject_sym_to_num(type)}']/../SubjectCode"
    end

    # return the interesting value of a Title composite
    #
    #   product.title(:distinct)
    #   product.title(:expanded)
    def title(type = :distinct)
      text_content "/Title/TitleType[text()='#{title_sym_to_num(type)}']/../TitleText"
    end

    # return the format of the product
    def product_form
      text_content '/ProductForm'
    end

    def product_form=(val)
      node = find_or_create('ProductForm')
      node.content = val.to_s
    end

    # return the number of pages the product has
    def number_of_pages
      numeric_content '/NumberOfPages'
    end

    def number_of_pages=(val)
      node = find_or_create('NumberOfPages')
      node.content = val.to_s
    end

    # return the edition number of the product
    def edition_number
      numeric_content '/EditionNumber'
    end

    def edition_number=(val)
      node = find_or_create('EditionNumber')
      node.content = val.to_s
    end

    # return the key BIC subject of the product
    def bic_main_subject
      text_content '/BICMainSubject'
    end

    def bic_main_subject=(val)
      node = find_or_create('BICMainSubject')
      node.content = val.to_s
    end

    # return the publishing status the product
    def publishing_status
      numeric_content '/PublishingStatus'
    end

    def publishing_status=(val)
      node = find_or_create('PublishingStatus')
      node.content = val.to_s
    end

    # return the date the product was/will be published
    def publication_date
      date_content '/PublicationDate'
    end

    def publication_date=(val)
      raise ArgumentError, 'objects passed to sent_date() must respond to strftime' unless val.respond_to?(:strftime)
      node = find_or_create('PublicationDate')
      node.content = val.strftime("%Y%m%d")
    end

    # return the year the original edition of the product was published
    def year_first_published
      text_content '/YearFirstPublished'
    end

    def year_first_published=(val)
      node = find_or_create('YearFirstPublished')
      node.content = val.to_s
    end

    private

    # based on ONIX codelist 5
    def id_sym_to_num(type)
      case type
      when :isbn10 then '02'
      when :isbn13 then '15'
      when :ean    then '03'
      else
        raise ArgumentError, '#{type} is not a recognised ID type'
      end
    end

    # based on ONIX codelist 27
    def subject_sym_to_num(type)
      case type
      when :dewey        then '01'
      when :bisac_cat    then '10'
      when :bisac_region then '11'
      when :bic_subject  then '12'
      when :bic_region   then '13'
      when :bic_lang     then '14'
      else
        raise ArgumentError, '#{type} is not a recognised Subject type'
      end
    end

    # based on ONIX codelist 15
    def title_sym_to_num(type)
      case type
      when :distinct then '01'
      when :origlang then '03'
      when :acronym  then '04'
      when :expanded then '13'
      else
        raise ArgumentError, '#{type} is not a recognised Title type'
      end
    end

  end
end

