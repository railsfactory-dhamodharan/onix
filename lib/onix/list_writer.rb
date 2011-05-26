# coding: utf-8

module ONIX
  module ListWriter
    
    def list_writer(name, options = {})
      options.symbolize_keys!
      unless options.is_a?(Hash) && options[:list].is_a?(Integer)
        raise ArgumentError, "Must specify code list number as ':list => Integer'"
      end
      define_method("#{name}=") do |value|
        # Value can be Array, String or Fixnum
        # To iterate over all classes, convert all to Array
        # NB: Some entities (j303, j304, j305) can be space-separated string of values
        values = case value.class.to_s
        when 'Array'
          value
        when 'String'
          value.split(/\s+/)
        else
          [value]
        end
        values.each do |value|
          unless value.nil? || ONIX::Lists.list(options[:list]).keys.include?(value)
            raise ArgumentError, "Invalid #{("_" + name.to_s).downcase.gsub!(/_(.)/) { $1.upcase }} '#{value}' -- Refer to ONIX Code List #{options[:list]}"
          end
        end
        # :as option determines how value is stored in instance variable
        values = if options[:as] == Array || options[:as] == []
          values
        elsif options[:as] == String
          values.join(" ")
        else
          values.first
        end
        self.instance_variable_set("@#{name}", values)
      end
    end
    
  end
end
