module FacebookApiCore
  module Apis
    class Users < AbstractApi
      
      def getInfo(uids, session)
        @request.params["method"] = "facebook.users.getInfo"
        @request.params["call_id"] = Time.now.to_i
        @request.params["uids"] = uids.join(',')
        @request.params["fields"] = "first_name,last_name,birthday,sex"
        @request.params["sig"] = _facebook_signature(@request.params)
        @response = @request.response
      end
      
    end
  end
end