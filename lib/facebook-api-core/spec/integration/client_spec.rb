require 'spec/spec_helper.rb'
require 'lib/client.rb'

describe FacebookApiCore::Client do
  
  before(:all) do
    @api_key      = API_KEY
    @secret_key   = SECRET_KEY
    
    @client = FacebookApiCore::Client.new(@api_key, @secret_key)
  end
  
  it "should initalize a new client" do
    @client.api_key.should eql(@api_key)
    @client.secret_key.should eql(@secret_key)
  end
  
  it "should return the relevant api on request" do
    @client.should_receive(:_get_api_for).with(:auth)
    @client.auth
  end
  
  it "should load the api file and instantiate it" do
    @client.auth.should be_a(FacebookApiCore::Apis::Auth)
    # @client.auth.createToken.should be_a(FacebookApiCore::Rest::Response)
    # @client.auth.createToken.body.root.content.should be_a(String)
    # puts @client.auth.createToken.body.root.content.inspect
  end
  
  
end