module FacebookApiCore
  module Apis
    class Auth < AbstractApi
      
      def createToken
        @request.params["method"] = "facebook.auth.createToken"
        @request.params["sig"] = _facebook_signature(@request.params)
        
        @response = @request.response
      end
      
      def getSession(auth_token)
        @request.params["auth_token"] = auth_token
        @request.params['generate_session_secret'] = false
        @request.params["method"] = "facebook.auth.getSession"
        @request.params["sig"] = _facebook_signature(@request.params)
        @response = @request.response
      end
      
    end
  end
end