require 'spec/spec_helper.rb'
require 'lib/client.rb'
require 'lib/apis/users.rb'

describe FacebookApiCore::Apis::Users do
  
  before(:all) do
    @api_key = API_KEY
    @secret_key = SECRET_KEY
  end
  
  it "should get info" do
    client = FacebookApiCore::Client.new(@api_key, @secret_key)
    response = client.users.getInfo(UIDS, SESSION_KEY)
    response.body.at_xpath("//fb:first_name", {"fb" => "http://api.facebook.com/1.0/"}).content.should eql("Luis")
  end
  
end