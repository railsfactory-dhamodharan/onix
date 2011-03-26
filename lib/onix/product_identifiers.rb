# coding: utf-8

module ONIX
  module ProductIdentifiers
    ACCESSOR_METHODS = {:proprietary_id => 1, :ean => 3, :isbn10 => 2, :isbn13 => 15, :isbn => 15, :lccn => 13}
    
    def initialize_product_identifiers(options)
      self.product_identifiers = options[:product_identifiers]
      # To initialize accessor methods, class in which this module is included
      # must also include Inflector and call initialize_attributes
    end
    
    ACCESSOR_METHODS.each do |name, digit|
      define_method(name) do
        identifier(digit).andand.id_value
      end
      define_method("#{name}=") do |value|
        identifier_set(digit, value)
      end
    end
    
    def product_identifiers
      @product_identifiers ||= []
    end

    private
    
    def product_identifiers=(values)
      values = [values] if values.nil? || values.is_a?(ONIX::ProductIdentifier)
      if values.is_a?(Array)
        # Empty array
        @product_identifiers = []
        # Add any valid value
        values.each do |value|
          @product_identifiers << value if value.is_a?(ONIX::ProductIdentifier)
        end
      else
        raise ArgumentError, "Invalid ProductIdentifier value: #{values.inspect}"
      end
    end

    # find the ProductIdentifier matching a particular type
    def identifier(type)
      raise NoMethodError, "NoMethodError : Must call initialize_product_identifiers first" unless defined?(@product_identifiers)
      @product_identifiers.find { |obj| obj.product_id_type == type }
    end

    # set the value of a particular ProductIdentifier (found by type)
    def identifier_set(type, value)
      obj = identifier(type)

      # create a new product identifier object if we necessary
      if obj.nil?
        obj = ONIX::ProductIdentifier.new
        obj.product_id_type = type
        @product_identifiers << obj
      end

      obj.id_value = value
    end
    
  end
end
