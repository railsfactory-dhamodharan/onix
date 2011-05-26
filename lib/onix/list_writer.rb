# coding: utf-8

module ONIX
  module ListWriter
    
    def list_writer(name, options = {})
      options.symbolize_keys!
      unless options.is_a?(Hash) && options[:list].is_a?(Integer)
        raise ArgumentError, "Must specify code list number as ':list => Integer'"
      end
      define_method("#{name}=") do |value|
        values = value.is_a?(Array) ? value : [value]
        values.each do |value|
          unless value.nil? || ONIX::Lists.list(options[:list]).keys.include?(value)
            raise ArgumentError, "Invalid #{("_" + name.to_s).downcase.gsub!(/_(.)/) { $1.upcase }} '#{value}' -- Refer to ONIX Code List #{options[:list]}"
          end
        end
        values = self.instance_variable_get("@#{name}").is_a?(Array) ? values : values.first
        self.instance_variable_set("@#{name}", values)
      end
    end
    
  end
end
