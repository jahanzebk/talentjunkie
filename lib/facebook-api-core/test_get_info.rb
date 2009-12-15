require 'rubygems'
require 'lib/client.rb'

client = FacebookApiCore::Client.new("1cf5c68a32ee955eebb88d1522d2d776", "d4c240922e7d23115e501c522b1e77ea")

r = client.users.getInfo(['615076059'], '3.FBuV21QWGNJatuJjCRCWvw__.86400.1260885600-615076059')

if r.is_a?(FacebookApiCore::Rest::ErrorResponse)
  puts r.error_msg
else
  puts r.body.inspect
  puts
  puts r.body.at_xpath("//fb:first_name", { 'fb' => 'http://api.facebook.com/1.0/'}).content
end