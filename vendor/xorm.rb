require 'ostruct'
require 'tempfile'
require 'uri'
require 'time'

require 'loader'
require 'xml/libxml'
require 'active_support/inflector'

# XORM is an xml-object relational mapping system for Ruby in much
# the same vein as xml-mapping or roxml (both available on rubyforge).
# The difference is that XORM uses LibXML as its parsing engine and is
# therefore noticeably faster than either xml-mapping or roxml (which
# both use the excellent native ruby REXML parser) on large files.
#
# Author::          David Gasson (mailto:dgasson@noao.edu)
# Copyright::       Copyright (c) 2007 National Optical Astronomy Observatory
# License::         GPL2
#
# Suppose you're interested creating or reading XML that looks like:
#
#  <VOTABLE version="1.0">
#    <RESOURCE type="results">
#      <TABLE>
#        <FIELD ID="Object" name="Object" ucd="VOX:Image_Title" datatype="char" arraysize="*"/>
#        <FIELD ID="Survey" name="Survey" ucd="ID_SURVEY" datatype="char" arraysize="*"/>
#        <FIELD ID="instrument" name="instrument" ucd="INST_ID" datatype="char" arraysize="*"/>
#        <FIELD ID="mjd-obs" name="mjd-obs" ucd="VOX:Image_MJDateObs" datatype="double"/>
#        <FIELD ID="RA" name="RA" ucd="POS_EQ_RA_MAIN" datatype="double"/>
#        <FIELD ID="DEC" name="DEC" ucd="POS_EQ_DEC_MAIN" datatype="double"/>
#       </TABLE>
#     </RESOURCE>
#     <RESOURCE type="more-results">
#       <TABLE> 
#         <FIELD ID="naxes" name="naxes" ucd="VOX:Image_Naxes" datatype="int"/>
#         <FIELD ID="naxis" name="naxis" ucd="VOX:Image_Naxis" datatype="int" arraysize="*"/>
#         <FIELD ID="scale" name="scale" ucd="VOX:Image_Scale" datatype="double" arraysize="*"/>
#         <FIELD ID="format" name="format" ucd="VOX:Image_Format" datatype="char" arraysize="*"/>
#         <FIELD ID="accessreference" name="accessreference" ucd="VOX:Image_AccessReference" datatype="char" arraysize="*"/>
#       </TABLE>
#     </RESOURCE>
#   </VOTABLE>
#
# ==== Defining Domain Objects
# The first step is to define the relationships between the different tags, which
# you might do as follows:
#
#  class Field < XORM::Base
#    name 'FIELD'
#
#    # These attributes are all strings, so we can define them all in one go.
#    has_attributes :ID, :name, :ucd, :datatype, :arraysize
#  end
#
#  class Table < XORM::Base
#    name 'TABLE'
#
#    has_a :data, Data, 'DATA'
#    has_many :fields, Field, 'FIELD'
#  end
#
#  class Resource < XORM::Base
#     name 'RESOURCE'
#  
#    has_attribute :type # The default attribute is a string
#    has_many :tables, Table, 'TABLE'
#  end
#
#  class VOTable < XORM::Base
#    # A VOTable's tag name (for use when outputting as XML)
#    # is 'VOTABLE'.  By default this is set to the
#    # class's name lowercased (i.e. votable--not what we want
#    # in this case).
#    name 'VOTABLE'
#
#    # The version attribute is a floating point value.
#    has_float_attribute :version
#
#    # A VOTable is composed of a list of resources of type Resource,
#    # the xpath address (i.e. tag name) of which is represented
#    # in XML as 'RESOURCE'.
#    has_many :resources, Resource, 'RESOURCE'  
#  end
#
# ==== Instantiating from Scratch
# You can build object as you'd expect:
#  vot = VOTable.new
#  vot[:version] = 1.0
#
#  res1 = Resource.new
#  res1[:type] = 'results'
#  vot.append_resource res1
#
#  tbl1 = Table.new
#  res1.append_table tbl1
#
#  field1 = Field.new
#  field1[:ID] = 'Object'
#  field1[:name] = 'Object'
#  field1[:ucd] = 'VOX:Image_Title'
#  field1[:datatype] = 'char'
#  field1[:arraysize] = '*'
#  tbl1.append_field field1
#
#  puts vot # To see the XML string representation
#
# ==== Instantiating from File/String
# You can also instantiate objects from String or File objects.
#  vot = VOTable.parse(File.new('my_votable.vot'))
# or
#  vot = VOTable.parse('<VOTABLE>..</VOTABLE>')
#
# ==== Accessing
# A number of accessors/iterators are also automatically defined:
#
#  res1 = vot.resources(0) #=> #<Resource:0x75d424>    # Retrieve the first resource
#  res = vot.resources() #=> [#<Resource:0x75d424>...] # Retrieve all resources as an array
#  vot.each_resource do |res, i|                       # Iterate through each resource
#    puts "Resource #{i}: #{res}"
#  end
#  num_res = vot.number_of_resources #=> 2             # Find the number of resources
#
# To delete a resource at a certain position:
#  vot.delete_resource(1)                              # Delete the second resource
module XORM
  
  # Defines the "domain specific language" (DSL) for XORM.
  module XORM_Class
    # Parse incoming data into a XORM class.   The data may represent
    # the underlying XML in any of three ways:
    # * an IO object (i.e. a file)
    # * a String
    # * a LibXML XML::Node
    # An appropriate subclass of XORM::Base is returned.
    def parse(data)
      if data.is_a?(IO)
        parser = XML::Parser.new
        parser.io = data
        xml = parser.parse.root
      elsif data.is_a?(String)
        parser = XML::Parser.new
        parser.string = data
        xml = parser.parse.root
      else
        xml = data
      end

      return self.new(xml)
    end

    # Set the name of the XML node.  This gets used
    # when a XORM object is serialized into XML--it
    # becomes the XML tag's name.  By default
    # it is set to XORM::Base subclass's name in lower
    # case.
    def name(name)
      @tag_name = name
    end
    
    # Retrieve the name of the tag that will be used
    # when the XORM::Base subclass is serialized to XML.
    def tag_name
      @tag_name ||= self.name.split('::').last.downcase
    end
    
    # Define an attribute.
    #  has_attribute :version
    # Supposing that obj is a XORM::Base subclass, these attributes can
    # be accessed in the following way:
    #  obj[:version] #=> 1.1
    #  obj['version'] #=> 1.1
    def has_attribute(name)
      attribute = attributes.find{ |a| a[:name] == name or a[:name] == name.to_sym }
      attributes << {:name => name} if !attribute
    end
    
    # Define a filter on a specified attribute.
    #  has_attribute_filter :retrieve, :version, :as_float
    # The action parameter may be one of: :retrieve, :save.
    # The filter parameter may be a symbol representing the name of a method
    # to call or a Proc object.  In the case of :retrieve, the filter
    # receives a string which can then be manipulated into whatever is appropriate.
    # In the case of :save, the filter retrieves a LibXML XML::Node which must then
    # be converted into a String.
    def attribute_filter(action, name, filter)
      attribute = attributes.find{ |a| a[:name] == name or a[:name] == name.to_sym }
      if attribute
        attribute.has_key?(:options) ? 
          attribute[:options][action] = filter : attribute[:options] = {action => filter}
      else
        attributes << {:name => name, :options => {action => filter}}
      end
    end
    
    # Defines an attribute as being a floating point number.
    #  has_float_attribute :version
    def has_float_attribute(name)
      has_attribute(name)
      attribute_filter(:retrieve, name, Proc.new{ |s| s ? s.to_f : nil })
    end
    
    # Defines an attribute as being a URI.
    #  has_uri_attribute :href
    def has_uri_attribute(name)
      has_attribute(name)
      attribute_filter(:retrieve, name, Proc.new{ |s| s ? URI.parse(s) : nil })
    end
    
    # Defines an attribute as being an integer value.
    #  has_integer_attribute :id
    def has_integer_attribute(name)
      has_attribute(name)
      attribute_filter(:retrieve, name, Proc.new{ |s| s ? s.to_i : nil })
    end
    
    # Defines an attribute as being a boolean value.
    #  has_boolean_attribute :isOpen
    def has_boolean_attribute(name)
      has_attribute(name)
      attribute_filter(:retrieve, name,
        Proc.new{ |s|
          if s
            s.downcase == 'true' ? true: false
          else
            nil
        end })
    end
    
    # Defines an attribute as being a boolean value, but
    # with yes/no semantics as opposed to true/false.
    #  has_yesno_attribute :isOpen
    def has_yesno_attribute(name)
      has_attribute(name)
      attribute_filter(:retrieve, name,
        Proc.new{ |s|
          if s
            s.downcase == 'yes' ? true: false
          else
            nil
          end })
      attribute_filter(:save, name, Proc.new { |b| b ? 'yes' : 'no' })
    end

    # Defines an attribute as being a datetime value.
    #  has_datetime_attribute :expires
    def has_datetime_attribute(name)
      has_attribute(name)
      attribute_filter(:retrieve, name, Proc.new{ |s| Time.parse(s) })
      attribute_filter(:save, name, Proc.new { |t| t.getutc.strftime("%Y-%m-%dT%H:%M:%SZ") })
    end
    
    # Defines a list of attributes assuming they are all text.
    #  has_attributes :ID, :name, :ucd, :datatype, :arraysize
    def has_attributes(*names)
      @attributes ||= []
      names.each do |name|
        has_attribute name
      end
    end

    # Returns a list of the attributes for the XORM::Base subclass
    # in question.
    def attributes
      @attributes ||= []
    end
    
    # Indicates that the XORM::Base subclass in question is composed
    # of a list of objects of the specified class, located by the
    # specified xpath.  xpath defaults to the singularized version of
    # the association_id.
    #  has_many :resources, Resource # xpath is 'resource'
    # vs.
    #  has_many :resources, Resource, 'RESOURCE'
    # Assuming obj is a XORM::Base subclass, the following methods
    # are created:
    #  obj.resources(n)                # return the nth resource
    #  obj.each_resource { |res, i| }  # iterate through each resource
    #  obj.delete_resource(n)          # delete the nth resource
    #  obj.delete_resources            # delete all resources
    #  obj.resources = [res1, res2]    # set resources
    #  obj.append_resource(res)        # append a resource
    #  obj.add_resources([res1, res2]) # append a list of resources
    #  obj.number_of_resources         # return the number of resources
    def has_many(association_id, klass, xpath=nil)
      xpath ||= Inflector.singularize(association_id)
      
      associations << {:id => association_id, :class => klass, :xpath => xpath}
    end
    
    # Return the list of associations associated with the XORM::Base class.
    def associations
      @associations ||= []
    end
    
    # Indicates that the XORM::Base subclass in question is wrapping
    # text only.  You can also specify whether that text should be
    # wrapped in a <![CDATA[...]]> tag upon serialization to XML (default is false).
    #  has_text :content, true
    # Assuming obj is a XORM::Base subclass
    #  obj.content
    # contains the text of the element.
    def has_text(association_id, is_cdata=false)
      xpath ||= Inflector.singularize(association_id)
      
      text_nodes << {:id => association_id, :cdata => is_cdata}
    end
    
    # Return the list of text nodes associated with the XORM::Base subclass.
    def text_nodes
      @text_nodes ||= []
    end
    
    # Define a filter on a specified association.
    #  association_filter :retrieve, :table_data, :do_retrieve
    # The action parameter may be one of: :retrieve, :save.
    # The filter parameter may be a symbol representing the name of a method
    # to call or a Proc object.  In the case of :retrieve, the filter
    # receives a XORM::Base object which can then be manipulated into whatever is appropriate.
    # In the case of :save, the filter retrieves a LibXML XML::Node which must then
    # be converted into a String.
    def association_filter(action, name, filter)
       assoc = single_associations.find{ |a| a[:id] == name or a[:id] == name.to_sym }
       assoc ? assoc[:options][action] = filter : single_associations << {:id => name, :options => {action => filter}}
    end
    
    # Indicates that the XORM::Base subclass in question is associated
    # with one (as opposed to a list) of other objects.  Works analogously
    # to has_many.  Assuming obj is a XORM::Base subclass, the following
    # methods are created:
    #  obj.resource = res   # set the resource
    #  obj.delete_resource  # delete the resource
    def has_a(association_id, klass, xpath=nil, name=nil)
      xpath ||= Inflector.singularize(association_id)
      
      assoc = single_associations.find{ |a| a[:id] == association_id or a[:id] == association_id.to_sym }
      klass.name(name) if name
      if assoc
        assoc[:class] = klass
        assoc[:xpath] = xpath
      else
        single_associations << {:id => association_id, :class => klass, :xpath => xpath}
      end
    end
    
    # Override the element name for the specified association.
    #  has_a :name, SimpleString, 'Name'
    #  set_name_for :name, 'StringValue'
    # Now instead of using the name set in SimpleString it will use StringValue.
    def set_name_for(association_id, name)
      assoc = single_associations.find{ |a| a[:id] == association_id or a[:id] == association_id.to_sym }
      if assoc
        assoc[:class].name(name)
      end
    end
    
    # Return the list of one-to-one associations composing the XORM::Base subclass.
    def single_associations
      @single_associations ||= []
    end
    
    # Add a validation to the class.
    #  validates :attribute_in_range
    # where the current class has a method called atttribute_in_range or
    #  validate Proc.new{ |obj| # verify here }
    # In either case the method or procedure will receive the base class and
    # must return an object with the following methods:
    # - validated: a boolean value indicating success/failure of validation
    # - context: the context of the error, usually the XORM::Base object itself
    # - msg: a string explaining the nature of the failure
    def validates(validator)
      self.validations.push(validator)
    end
    
    # Validates whether the specified attribute is one of a specified
    # list.
    #  validates_attribute_one_of :system, 'eq_FK5', 'eq_FK4', 'ICRS'
    def validates_attribute_one_of(name, *choices)
      in_list = Proc.new{ |obj|
        result = OpenStruct.new({'context' => obj})
        
        if obj[name]
          in_list = choices.include?(obj[name]) or choices.include?(obj[name.to_s])
          result.validated = in_list
          result.msg = "#{name} '#{obj[name]}' must be one of: #{choices.join(', ')}" if !in_list
        else
          result.validated = true
        end
        
        result
      }
      
      validates in_list
    end
    
    # Validates whether the specified attribute is set.
    #  validate_attribute_presence :ID
    def validates_attribute_presence(name)
      presence = Proc.new { |obj|
        present = (obj[name] != nil or obj[name.to_s] != nil)
 
        result = OpenStruct.new
        result.validated = present
        result.context = obj
        result.msg = "#{name} is not set" if !present
        
        result
      }
      
      validates presence
    end
    
    # Validates whether the specified attribute matches the
    # given regular expression.
    #  validates_attribute_matches :year, /^[JB]?[0-9]+([.][0-9]*)?$/
    def validates_attribute_matches(name, regex)
      regex = Regexp.new(regex) if !regex.is_a?(Regexp)
      
      matches = Proc.new { |obj|
        result = OpenStruct.new({'context' => obj})
        
        if obj[name]
          result.validated = obj[name].match(regex) ? true : false
          result.msg = "#{name} '#{obj[name]}' does not match #{regex}" if !result.validated
        else
          result.validated = true
        end
        
        result
      }
      
      validates matches
    end
    
    # Validates whether the specified attribute is a non-negative integer.
    def validates_attribute_non_negative_integer(name)
      non_neg = Proc.new { |obj|
        result = OpenStruct.new({'context' => obj})
        
        if obj[name]
          result.validated = (obj[name].to_i >= 0)
          result.msg = "#{name} '#{obj[name]}' is not a positive number"
        else
          result.validated = true
        end
        
        result
      }
      
      validates non_neg
    end
    
    # Validates whether the specified attribute is a positive integer.
    def validates_attribute_positive_integer(name)
      positive = Proc.new { |obj|
        result = OpenStruct.new({'context' => obj})
        
        if obj[name]
          result.validated = (obj[name].to_i > 0)
          result.msg = "#{name} '#{obj[name]}' is not a positive number"
        else
          result.validated = true
        end
        
        result
      }
      
      validates positive
    end
    
    # Return a list of validations to runs against the XORM::Base subclass.
    def validations
      @validations ||= []
    end
    
    # Decide whether association i has the named option set.
    def has_option?(i, option_name)
      assoc = associations[i]
      
      assoc and
      assoc.has_key?(:options) and
      assoc[:options] and
      assoc[:options].has_key?(option_name) and
      assoc[:options][option_name]
    end
    
    # Define a validator on the object.
    
    # Creates the appropriate class methods.  There is no need to ever
    # call this directly.
    def create_methods
      create_text_accessors()
      create_object_accessors()
      create_array_accessors()
    end
    
    # Escape an xpath expression.
    def escape_xpath(xpath)
      xpath ||= ''
      xpath.gsub('"', '\"')
    end

    private
    
    def create_text_accessors
      text_nodes.each do |assoc|
        text_reader = %Q{
          def #{assoc[:id]}
            @node.content
          end
        }
        module_eval text_reader if !method_defined?(assoc[:id])
        
        text_writer = %Q{
          def #{assoc[:id]}=(txt)
            xnode = XML::Node.new(self.class.tag_name())
          
            properties = @node.properties || []
            properties.each do |prop|
              xnode[prop.name] = prop.value
            end
            
            #{assoc[:cdata] ? 'xnode << XML::Node.new_cdata(txt.to_s)' : 'xnode.content = txt.to_s'}
            
            @node = xnode
          end
        }
        module_eval text_writer if !method_defined?("#{assoc[:id]}=")
      end
    end
    
    def create_object_accessors
      single_associations.each do |assoc|
        reader = %Q{
          def #{assoc[:id]}
            node = @node.find_first(\"#{escape_xpath(assoc[:xpath])}\")
            result = node ? #{assoc[:class]}.parse(node): nil
            
            assoc_attr = self.class.single_associations.find{ |a|
                a[:id] == '#{assoc[:id]}'.to_sym or a[:id] == '#{assoc[:id]}'
            }
            if assoc_attr and assoc_attr.has_key?(:options) and
               assoc_attr[:options].has_key?(:retrieve) and
               assoc_attr[:options][:retrieve]
              if assoc_attr[:options][:retrieve].is_a?(Symbol)
                result = self.send(assoc_attr[:options][:retrieve], result) || result
              else
                result = assoc_attr[:options][:retrieve].call(result) || result
              end
            end
            
            result
          end
        }
        module_eval reader if !method_defined?(assoc[:id])
        
        writer = %Q{
          def #{assoc[:id]}=(obj)
            assoc_attr = self.class.single_associations.find{ |a| a[:id] == '#{assoc[:id]}' }
            if assoc_attr and assoc_attr.has_key?(:options) and
               assoc_attr[:options].has_key?(:save) and
               assoc_attr[:options][:save]
               if assoc_attr[:options][:save].is_a?(Symbol)
                 obj = self.send(assoc_attr[:options][:save], obj) || obj
               else
                 obj = assoc_attr[:options][:save].call(obj) || obj
               end
            end
            
            raise RuntimeError, \"'\#{obj}' (\#{obj.class}) is not of type #{assoc[:class]}\" if !obj.is_a?(#{assoc[:class]})
            delete_#{assoc[:id]}()
            
            @node << obj.node
          end
        }
        module_eval writer if !method_defined?("#{assoc[:id]}=")
        
        delete = %Q{
          def delete_#{assoc[:id]}
            matching_node = @node.find_first(\"#{escape_xpath(assoc[:xpath])}\")
            matching_node.remove! if matching_node
          end
        }
        module_eval delete if !method_defined?("delete_#{assoc[:id]}")
      end
    end

    def create_array_accessors
      associations.each do |assoc|
        reader = %Q{
          def #{assoc[:id]}(i)
            results = nil
            matching_node = @node.find_first(\"#{escape_xpath(assoc[:xpath])}[\#{i+1}]\")
            results = matching_node ? #{assoc[:class]}.parse(matching_node): nil
            
            results
          end
        }
        module_eval reader if !method_defined?(assoc[:id])
        
        multi_writer = %Q{
          def #{assoc[:id]}=(list)
            list = [list] if !list.respond_to?(:each)

            delete_#{assoc[:id]}
            add_#{assoc[:id]}(*list)
          end
        }
        module_eval multi_writer if !method_defined?("#{assoc[:id]}=")
         
        appender = %Q{
          def append_#{Inflector.singularize(assoc[:id])}(obj)
            raise RuntimeError, \"'\#{obj}' (\#{obj.class}) is not of type #{assoc[:class]}\" if !obj.is_a?(#{assoc[:class]})
            @node << obj.node
          end
        }
        module_eval appender if !method_defined?("append_#{Inflector.singularize(assoc[:id])}")
        
        multi_appender = %Q{
          def add_#{assoc[:id]}(*obj_list)
            obj_list.each do |obj|
              append_#{Inflector.singularize(assoc[:id])}(obj)
            end
          end
        }
        module_eval multi_appender if !method_defined?("add_#{assoc[:id]}")
        
        delete = %Q{
          def delete_#{Inflector.singularize(assoc[:id])}(i=0)
            matching_node = @node.find_first(\"#{escape_xpath(assoc[:xpath])}[\#{i+1}]\")
            matching_node.remove! if matching_node
          end
        }
        module_eval delete if !method_defined?("delete_#{Inflector.singularize(assoc[:id])}")
        
        multi_delete = %Q{
          def delete_#{assoc[:id]}
            @node.find(\"#{escape_xpath(assoc[:xpath])}\").each do |node|
              node.remove!
            end
          end
        }
        module_eval multi_delete if !method_defined?("delete_#{assoc[:id]}")
         
        iterator = %Q{
          def each_#{Inflector.singularize(assoc[:id])}
            i = 0
            @node.find(\"#{escape_xpath(assoc[:xpath])}\").each do |matching_node|
              yield #{assoc[:class]}.parse(matching_node), i
              i += 1
            end
          end
        }
        module_eval iterator if !method_defined?("each_#{Inflector.singularize(assoc[:id])}")
         
        length = %Q{
          def number_of_#{assoc[:id]}
            @node.find(\"#{escape_xpath(assoc[:xpath])}\").length
          end
        }
        module_eval length if !method_defined?("number_of_#{assoc[:id]}")
      end
    end
  end

  class << self
      #
      # Extends the klass with the XORM_Class module methods.
      #
      def included(klass)
          super
          klass.__send__(:extend, XORM_Class)
      end
  end
  
  # The base class for any XORM object.
  #  class MyClass < XORM::Base
  #    # define your domain here...
  #  end
  class Base
    include XORM
    
    # The underlying XML::Node
    attr_reader :node
    
    # Create a new XORM::Base subclass, either from
    # a XML::Node or (more usually) from scratch.
    def initialize(node=nil)
      @node = node ? node : create_new_node()

      self.class.create_methods()
    end
    
    # Retrieve an attribute.  Both
    #  obj[:my_attr]
    # and
    #  obj['my_attr']
    # should work.  There is also an optional namespace
    # parameter, which lets you discriminate.  So
    #  obj['my_attr', 'http://www.noao.edu/']
    # would only return the value of my_attr if its namespace
    # was http://www.noao.edu, otherwise nil.
    def [](attr_name, ns_uri=nil)
      att_def = self.class.attributes.find{ |att| att[:name] == attr_name.to_sym }
      return nil if !att_def
      
      value = nil
      if ns_uri
        ns_prefix = @node.search_href(ns_uri)
        if ns_prefix
          matching_node = @node.find("@#{ns_prefix}:#{attr_name}")
          if matching_node.to_a.size > 0
            value = matching_node ? matching_node.to_a.first.to_s.split('=').last.gsub('"', '') : nil
          else
            value = nil
          end
        else
          value = nil
        end
      else
        matching_node = @node.find("@#{attr_name}")
        if matching_node.to_a.size > 0
          value = matching_node ? matching_node.to_a.first.to_s.split('=').last.gsub('"', '') : nil
        else
          value = nil
        end
      end

      result = nil
      if att_def.has_key?(:options) and att_def[:options].has_key?(:retrieve) and att_def[:options][:retrieve]
        if att_def[:options][:retrieve].is_a?(Symbol)
          result = self.send(att_def[:options][:retrieve], value)
        else
          result = att_def[:options][:retrieve].call(value)
        end
      else
        result = value
      end

      result
    end

    # Set the value of an attribute.
    #  obj[:my_attr] = 'Hello, world!'
    # Note that once an attribute has been created it's currently
    # impossible to get ride of it entirely.  That is,
    #   obj[:my_attr] = undef
    # doesn't work as you'd expect.  It's also possible to provide
    # a namespace
    #  obj[:my_attr, 'http://www.noao.edu/'] = 'Hello, world!'
    def []=(attr_name, *options)
      raise ArgumentError, "Must provide at least a value" if options.size < 1
      ns_uri, value = nil, nil
      value = options[-1]
      ns_uri = options[-2] if options.size > 1
      
      att_def = self.class.attributes.find{ |att| att[:name] == attr_name.to_sym }
      raise RuntimeError, "Attribute '#{attr_name}' undefined for #{self.class}" if !att_def

      if att_def.has_key?(:options) and att_def[:options].has_key?(:save) and att_def[:options][:save]
        if att_def[:options][:save].is_a?(Symbol)
          value = self.send(att_def[:options][:save], value) || value ;
        else
          value = att_def[:options][:save].call(value) || value
        end
      end

      if ns_uri
        ns = @node.search_href(ns_uri)
        @node["#{ns.prefix}:#{attr_name}"] = value.to_s
      else
        @node[attr_name] = value.to_s
      end
    end
    
    # Validate the object according to the defined rules.
    # Returns an array of negative validation results.
    def validate
      results = []
      
      # Local validations
      self.class.validations.each do |validator|
        result = validator.is_a?(Symbol) ? self.send(validator, self) : validator.call(self)
        results.push(result) if !result.validated
      end
      
      # Single association validations
      self.class.single_associations.each do |assoc|
        obj = self.send(assoc[:id])
        if obj.respond_to?(:validate)
          results.push(*obj.validate)
        end
      end
      
      # Multiple association validations
      self.class.associations.each do |assoc|
        num_objs = self.send("number_of_#{assoc[:id]}")
        (0..num_objs-1).each do |i| # validate each member of the association
          obj = self.send("#{assoc[:id]}", i)
          if obj.respond_to?(:validate)
            results.push(*obj.validate)
          end
        end
      end
      
      results
    end
    
    # Save the XORM::Base subclass to file as XML.
    def save(filename)
      doc = XML::Document.new()
      doc.root = self.node
      
      doc.save(filename, true)
    end
    
    # Convert the XORM::Base subclass to XML.
    def to_s
      self.node.to_s
    end
    
    private
    
    # This is a hack for the Node namespace problem libxml seems to
    # have.  Find seems to fail in certain situations if you simply
    # instantiate a new XML::Node from scratch.
    def create_new_node
      t = save_to_file("<#{self.class.tag_name}></#{self.class.tag_name}>")
      node = XML::Document.file(t.path).root
      t.close
      
      node
    end
    
    def save_to_file(txt, file=nil)
      t = file ? File.open(file, 'r+') : Tempfile.new('xml_fragment')
      t.puts(txt)
      t.fsync
      
      t
    end
  end
  
  class ValidationError < RuntimeError; end
end


