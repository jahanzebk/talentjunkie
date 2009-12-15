require 'rubygems'
require 'nokogiri'

module FacebookApiCore
  module Rest
    class Response
      
      class << self
        def build http_response
          Nokogiri::XML(http_response.body.strip).xpath("//fb:error_response", { "fb" => "http://api.facebook.com/1.0/"}).size == 0 ? Response.new(http_response) : ErrorResponse.new(http_response)
        end
      end
      
      attr_reader :http_status_code, :body
      
      def initialize(http_response)
        @http_response = http_response
        @http_status_code = @http_response.code
        @body = Nokogiri::XML(http_response.body.strip)
      end
    end
    
    class ErrorResponse < Response
      
      def error_code
        @body.at_xpath("//fb:error_code", { "fb" => "http://api.facebook.com/1.0/"}).content
      end
      
      def error_msg
        @body.at_xpath("//fb:error_msg", { "fb" => "http://api.facebook.com/1.0/"}).content
      end
    end
    
  end
end