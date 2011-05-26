# coding: utf-8

module ONIX
  module WorkIdentifiers
    ID_TYPES = {:proprietary_id => 1, :isbn10 => 2, :isbn13 => 15, :isbn => 15}
    
    def initialize_work_identifiers(options = {})
      self.work_identifiers = options[:work_identifiers]
      # To initialize accessor methods, class in which this module is included
      # must also include Inflector and call initialize_attributes
    end
    
    def work_identifiers
      @work_identifiers ||= []
    end

    # find the WorkIdentifier matching a particular type
    def find_work_identifier(options = {})
      raise NoMethodError, "Must call initialize_work_identifiers first" unless defined?(@work_identifiers)
      
      # test find parameters
      attribute, value = set_type_options(options).first
      raise ArgumentError, "Find method passed unknown attribute '#{attribute}'" unless ONIX::WorkIdentifier.new.attributes.include?(attribute.to_s)
      
      @work_identifiers.find { |obj| obj.send(attribute) == value }
    end

    # set the value of a particular WorkIdentifier (found by type)
    # type can be either type code or key from ID_TYPES
    def set_work_identifier(type, value)
      obj = find_work_identifier(type)

      # create a new work identifier object if necessary
      if obj.nil?
        obj = ONIX::WorkIdentifier.new(set_type_options(type))
        @work_identifiers << obj
      end

      obj.id_value = value
    end
    
    def work_identifiers=(values)
      values = [values] if values.nil? || values.is_a?(ONIX::WorkIdentifier)
      if values.is_a?(Array)
        # Empty array
        @work_identifiers = []
        # Add any valid value
        values.each do |value|
          @work_identifiers << value if value.is_a?(ONIX::WorkIdentifier)
        end
      else
        raise ArgumentError, "Invalid WorkIdentifier value: #{values.inspect}"
      end
    end

    private

    def set_type_options(options = {})
      if options.is_a?(Fixnum)
        # assume value is 'work_id_type'
        options = {:work_id_type => options}
      elsif options.is_a?(String) || options.is_a?(Symbol)
        # assume value is the key to ID_TYPES
        if key = ID_TYPES[options.to_sym]
          options = {:work_id_type => ID_TYPES[options.to_sym]}
        else
          raise ArgumentError, "Unknown key '#{options}'"
        end
      end
      options
    end

  end
end
