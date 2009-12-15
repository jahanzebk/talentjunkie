require 'rubygems'
require 'lib/xmlmini'

xml = '<?xml version="1.0" encoding="UTF-8"?><top_level_tag><users><user>user one</user><user>user two</user></users></top_level_tag>'

n = Nokogiri::XML(xml)

puts n.to_hash.inspect
