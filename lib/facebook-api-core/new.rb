require 'rubygems'
require 'nokogiri'

# = XmlMini Nokogiri implementation
module XmlMini_Nokogiri #:nodoc:
  extend self

  # Parse an XML Document string into a simple hash using libxml / nokogiri.
  # string::
  #   XML Document string to parse
  def parse(string)
    if string.blank?
      {}
    else
      doc = Nokogiri::XML(string)
      raise doc.errors.first if doc.errors.length > 0
      doc.to_hash
    end
  end

  module Conversions
    module Document
      def to_hash
        root.to_hash
      end
    end

    module Node
      CONTENT_ROOT = '__content__'

      # Convert XML document to hash
      #
      # hash::
      #   Hash to merge the converted element into.
      def to_hash(hash = {})
        
        if self.text?
          hash = [self.content]
        else
          children.each do |c|
            hash_or_array = c.to_hash
            if hash_or_array.is_a?(Array)
              puts "ARRAY"
              puts hash_or_array.inspect
              puts "hash[name]=#{hash[name].inspect}"
              hash[name] = [] unless hash[name].is_a?(Array)
              hash[name] << hash_or_array
            else
              puts "HASH"
              puts hash_or_array.inspect
              puts "hash[name]=#{hash[name].inspect}"
              hash[name] = {} unless hash[name].is_a?(Hash)
              hash[name] = hash_or_array
            end
            
          end
        end
        
        hash
      end
    end
  end

  Nokogiri::XML::Document.send(:include, Conversions::Document)
  Nokogiri::XML::Node.send(:include, Conversions::Node)
end




xml = '<?xml version="1.0" encoding="UTF-8"?><top_level_tag><users><user>user one</user><user>user two</user></users></top_level_tag>'

n = Nokogiri::XML(xml)

puts n.to_hash.inspect


