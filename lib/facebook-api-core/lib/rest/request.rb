require 'net/http'
require 'uri'
require File.join(File.dirname(__FILE__), "response.rb")
require 'digest/md5'


module FacebookApiCore
  module Rest
    class Request
  
  
      attr_accessor :method, :params
      attr_reader :url
  
      def initialize(url, method = :get, *args)
        @url = url
        @method = method
        @params = {}
      end
  
      def response
        @response ||= Response::build(_do_request_and_get_response)
      end
      
      private
      
      def _do_request_and_get_response
        send("_#{@method}")
      end
      
      def _get
        Net::HTTP.start(@url.host, @url.port) do |http|
          params = @params.sort.map {|k,v| "#{k.to_s}=#{v}"}.join("&")
          http.get('/restserver.php?' + params)
        end
      end
      
      def _post
      end
      
    end
  end
end