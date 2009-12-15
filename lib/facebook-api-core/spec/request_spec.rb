require 'spec/spec_helper.rb'
require 'lib/rest/request.rb'

describe FacebookApiCore::Rest::Request do
  
  before(:all) do
    @url = URI.parse("http://api.facebook.com")
  end
  
  before(:each) do
    @request = FacebookApiCore::Rest::Request.new(@url)
  end
  
  it "should initialize the Request object" do
    @request.url.should eql(@url)
  end
  
  it "should allow paramaters to be set and read" do
    @request.params[:param1] = "12345"
    @request.params[:param1].should eql("12345")
  end
  
  it "should make the call and return a response" do
    @request.response.should be_a(FacebookApiCore::Rest::Response)
  end
end