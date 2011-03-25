# coding: utf-8

module ONIX
  module ListWriter
    
    def list_writer(name, options = {})
      options.symbolize_keys!
      unless options.is_a?(Hash) && options[:list].is_a?(Integer)
        raise ArgumentError, "Must specify code list number as ':list => Integer'"
      end
      define_method("#{name}=") do |value|
        if value.nil? || ONIX::Lists.list(options[:list]).keys.include?(value)
          self.instance_variable_set("@#{name}", value)
        else
          raise ArgumentError, "Invalid #{name} value: #{value}"
        end
      end
    end
    
  end
end
