require 'digest/md5'

module FacebookApiCore
  module Apis
    class AbstractApi
      
      def initialize(api_key, secret_key, request)
        @api_key = api_key
        @secret_key = secret_key
        @request = request
        @request.params.merge!({"v" => "1.0", "api_key" => @api_key})
      end

      private
      
      def _facebook_signature(params)
        params_string = params.sort.map{|pair| pair.join("=")}.join
        Digest::MD5.hexdigest(params_string + @secret_key)
      end
    end
  end
end