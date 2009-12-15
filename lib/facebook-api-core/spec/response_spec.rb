require 'spec/spec_helper.rb'
require 'lib/rest/request.rb'

describe FacebookApiCore::Rest::Response do
  
  before(:all) do
  end
  
  before(:each) do
  end
  
  it "should initialize the Response object" do
    @http_response = mock(Net::HTTPResponse, :code => "200", :body => '<?xml version="1.0" encoding="UTF-8"?><some_response>content here</some_response>')
    @response = FacebookApiCore::Rest::Response::build(@http_response)
    
    @response.http_status_code.should eql(@http_response.code)
    @response.should be_a(FacebookApiCore::Rest::Response)
  end

  it "should return response elements according to document structure" do
    @http_response = mock(Net::HTTPResponse, :code => "200", :body => '<?xml version="1.0" encoding="UTF-8"?><top_level_tag><users><user>user one</user><user>user two</user></users></top_level_tag>')
    @response = FacebookApiCore::Rest::Response::build(@http_response)
    # @response.document[:users][:user][0].should eql('user one')
    # @response.document[:users][:user][1].should eql('user two')
  end
  
  it "should return the value when only the top level exists" do
    token = "a3cab3d3df9011412ad71713db323eb6"
    @http_response = mock(Net::HTTPResponse, :code => "200", :body => '<?xml version="1.0" encoding="UTF-8"?><auth_createToken_response xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd">' + token + '</auth_createToken_response>')
    @response = FacebookApiCore::Rest::Response::build(@http_response)
    @response.body.at_xpath("//auth_createToken_response").content.should eql(token)
  end
  
end

describe FacebookApiCore::Rest::ErrorResponse do
  
  it "should return an ErrorResponse object" do
    error_code = "123"
    error_msg = "An error here"
    @http_response = mock(Net::HTTPResponse, :code => "200", :body => '<?xml version="1.0" encoding="UTF-8"?><error_response xmlns="http://api.facebook.com/1.0/"><error_code>' + error_code + '</error_code><error_msg>' + error_msg + '</error_msg></error_response>')
    @response = FacebookApiCore::Rest::Response::build(@http_response)
    @response.should be_a(FacebookApiCore::Rest::ErrorResponse)
    @response.body.at_xpath("//fb:error_code", { 'fb' => "http://api.facebook.com/1.0/"}).content.should eql(error_code)
    @response.body.at_xpath("//fb:error_msg", { 'fb' => "http://api.facebook.com/1.0/"}).content.should eql(error_msg)
  end
  
end