require 'spec/spec_helper.rb'
require 'lib/client.rb'
require 'lib/apis/auth.rb'

describe FacebookApiCore::Apis::Auth do
  
  before(:all) do
    @api_key = API_KEY
    @secret_key = SECRET_KEY
  end
  
  it "should return a token" do
    # client = FacebookApiCore::Client.new(@api_key, @secret_key)
    # @response = client.auth.createToken
    # @response.should be_a(FacebookApiCore::Rest::Response)
    # @response.http_status_code.should eql("200")
    # @response.body.root.content.should be_a(String)
    # # puts @client.auth.createToken.body.root.content.inspect
  end
  
  it "should get a session" do
    client = FacebookApiCore::Client.new(@api_key, @secret_key)
    token = client.auth.createToken.body.root.content
    
    client = FacebookApiCore::Client.new(@api_key, @secret_key)
    # @response = client.auth.getSession(token)
    # raise @response.error_msg.inspect
  end
  
end