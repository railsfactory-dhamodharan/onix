# coding: utf-8

module ONIX
  module DiscountCodeds
    CODE_TYPES = {:bic => 1, :proprietary => 2, :boeksoort => 3, :german => 4}
    DEFAULT_ATTRIBUTE = :discount_code_type
    
    def initialize_discount_codeds(options = {})
      self.discount_codeds = options[:discount_codeds]
    end
    
    def discount_codeds
      @discount_codeds ||= []
    end

    # find the DiscountCoded matching a particular type
    def find_discount_coded(options = {})
      raise NoMethodError, "Must call initialize_discount_codeds first" unless defined?(@discount_codeds)
      
      # test find parameters
      attribute, value = set_type_options(options).first
      raise ArgumentError, "Find method passed unknown attribute '#{attribute}'" unless ONIX::DiscountCoded.new.attributes.include?(attribute.to_s)
      
      @discount_codeds.find { |obj| obj.send(attribute) == value }
    end

    # set the value of a particular DiscountCoded (found by type)
    # type can be either type code or key from CODE_TYPES
    def set_discount_coded(type, value)
      obj = find_discount_coded(type)

      # create a new discount_coded object if necessary
      if obj.nil?
        obj = ONIX::DiscountCoded.new(set_type_options(type))
        @discount_codeds << obj
      end

      obj.discount_code = value
    end
    
    private

    def discount_codeds=(values)
      values = [values] if values.nil? || values.is_a?(ONIX::DiscountCoded)
      if values.is_a?(Array)
        # Empty array
        @discount_codeds = []
        # Add any valid value
        values.each do |value|
          @discount_codeds << value if value.is_a?(ONIX::DiscountCoded)
        end
      else
        raise ArgumentError, "Invalid DiscountCoded value: #{values.inspect}"
      end
    end

    def set_type_options(options = {})
      if options.is_a?(Fixnum)
        # assume value is DEFAULT_ATTRIBUTE
        options = {DEFAULT_ATTRIBUTE => options}
      elsif options.is_a?(String) || options.is_a?(Symbol)
        # assume value is the key to CODE_TYPES
        if key = CODE_TYPES[options.to_sym]
          options = {DEFAULT_ATTRIBUTE => CODE_TYPES[options.to_sym]}
        else
          raise ArgumentError, "Unknown key '#{options}'"
        end
      end
      options
    end

  end
end
