# utf-8

module ONIX
  module Inflector
    
    def initialize(options = {})
      initialize_attributes(options)
    end
    
    def attributes
      public_methods.map {|meth| meth.match(/^(?!roxml|taguri|=)(.+)=$/) ? $1 : nil }.compact
    end
    
    private
    
    def initialize_attributes(options)
      options.symbolize_keys!
      attributes.each do |attribute|
        self.send("#{attribute}=", options[attribute.to_sym])
      end
    end
    
  end
end