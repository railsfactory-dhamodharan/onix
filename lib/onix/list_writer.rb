# coding: utf-8

module ONIX
  module ListWriter
    
    def list_writer(name, digit)
      define_method("#{name}=") do |value|
        if value.nil? || ONIX::Lists.list(digit).keys.include?(value)
          self.instance_variable_set("@#{name}", value)
        else
          raise "Invalid #{name} value: #{value}"
        end
      end
    end
    
  end
end
