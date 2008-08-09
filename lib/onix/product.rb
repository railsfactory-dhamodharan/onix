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
        @root_node = XML::Node.new("Product")
      end 
    end

    def record_reference
      text_content '/RecordReference'
    end

    def record_reference=(val)
      if node = root.find_first('/RecordReference')
        node.content = val
      else
        node = XML::New.new("RecordReference")
        node.content = val
        root << node
      end
    end

    def notification_type
      numeric_content '/NotificationType'
    end

    def notification_type=(val)
      if node = @root_node.find_first('/NotificationType')
        node.content = val
      else
        node = XML::New.new("NotificationType")
        node.content = val
        @root_node << node
      end
    end

    # return the interesting value of a ProductIdentifier composite
    #
    #   product.id(:isbn10)
    #   product.id(:isbn13)
    #   product.id(:ean)
    def id(type = :ean)
      text_content "/ProductIdentifier/ProductIDType[text()='#{id_sym_to_num(type)}']/../IDValue"
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

    # return the number of pages the product has
    def number_of_pages
      numeric_content '/NumberOfPages'
    end

    # return the edition number of the product
    def edition_number
      numeric_content '/EditionNumber'
    end

    # return the key BIC subject of the product
    def bic_main_subject
      text_content '/BICMainSubject'
    end

    # return the publishing status the product
    def publishing_status
      numeric_content '/PublishingStatus'
    end

    # return the date the product was/will be published
    def publication_date
      date_content '/PublicationDate'
    end

    # return the year the original edition of the product was published
    def year_first_published
      text_content '/YearFirstPublished'
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

