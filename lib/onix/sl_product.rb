# coding: utf-8

module ONIX
  class SLProduct < APAProduct
    
    delegate :audience_code, :audience_code=
    delegate :copyright_year, :copyright_year=
    delegate :product_form_detail, :product_form_detail=
    
    # retrieve the value of a particular ID
    def series(str)
      product.series.find { |id| id.title_of_series == str }
    end

    # set the value of a particular ID
    def series=(value)
      # process based on value type
      if value.is_a?(Series)
        str = value.title_of_series
        series_id = value
      else
        str = value
        series_id = ONIX::Series.new
        series_id.title_of_series = value
      end
      # check if exists already
      unless series(str)
        product.series << series_id
      end
    end
    
    # retrieve the value of a particular ID
    def set(str)
      product.sets.find { |id| id.title_of_set == str }
    end

    # set the value of a particular ID
    def set=(value)
      # process based on value type
      if value.is_a?(Set)
        str = value.title_of_set
        set_id = value
      else
        str = value
        set_id = ONIX::Set.new
        set_id.title_of_set = value
      end
      # check if exists already
      unless set(str)
        product.sets << set_id
      end
    end
    
    # retrieve an array of all languages
    def languages
      product.languages.collect { |language| language.language_code}
    end

    # set a new language to this product
    # str should be the languages name code (US)
    def add_language(str, role = "1", country = "US")
      language = ::ONIX::Language.new
      language.language_role = role
      language.language_code = str
      language.country_code = country
      product.languages << language
    end
    
    # retrieve the dewey for this title
    def dewey
      product.subjects.find { |sub| sub.subject_scheme_id.to_i == 1 } # dewey = 1, abridged dewey = 2
    end

    # add a dewey to the product
    def dewey=(code)
      add_subject code, "1" # dewey = 1, abridged dewey = 2
    end
    
    # audience_range_qualifier: 11 = US school grades
    # audience_range_precision: 1 = exact, 3 = from, 4 = to
    def us_grade_range
      audience_range(11)
    end

    # set a new "audience of text" (role=1) country code for this particular product
    def us_grade_range=(range=[])
      audience_range_set(11, range[0], range[1])
    end

    # retrieve the value of a particular audience range
    def audience_range(type)
      product.audience_ranges.find { |a| a.audience_range_qualifier == type }
    end

    # set the value of a particular audience_range
    def audience_range_set(type, min=nil, max=nil)
      a = audience_range(type)

      # create a new audience_range record if we need to
      if a.nil?
        a = ONIX::AudienceRange.new
        a.audience_range_qualifier = type
        product.audience_ranges << a
      end

      unless min.nil?
        a.audience_range_precisions << "03"
        a.audience_range_values << min
      end
      unless max.nil?
        a.audience_range_precisions << "04"
        a.audience_range_values << max
      end
      a.audience_range_precisions = ["01"] if min.nil? || max.nil?
    end
    
  end
end
