require 'rubygems'
# require 'typhoeus'
# require 'json'

require File.join(File.dirname(__FILE__), "apis", "abstract_api.rb")
require File.join(File.dirname(__FILE__), "rest", "request.rb")
require File.join(File.dirname(__FILE__), "rest", "response.rb")

module FacebookApiCore
  class Client
    
    attr_reader :api_key, :secret_key
    
    
    # The Client takes an api_key and an api_secret.
    #
    #
    def initialize(api_key, secret_key)
      @api_key = api_key
      @secret_key = secret_key
    end

    def method_missing(interface_name, *args)
      begin
        _get_api_for(interface_name)
      rescue
        raise
      end
    end
    
    private
    
    def _get_api_for(interface_name)
      class_name = interface_name.to_s
      require File.join(File.dirname(__FILE__), "apis", "#{class_name}.rb")  
      FacebookApiCore::Apis.const_get(class_name.capitalize).new(@api_key, @secret_key, FacebookApiCore::Rest::Request.new(URI.parse("http://api.facebook.com")))
    end
  end
end