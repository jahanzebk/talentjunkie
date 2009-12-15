class SessionsFbController < PublicController

  skip_before_filter :redirect_if_session_exists
  
  def create
    begin
      @request_path = session[:request_path]
      reset_session
      
      @fb_config = YAML::load(File.open("#{RAILS_ROOT}/config/facebooker.yml"))
      @fb_api_key = @fb_config[RAILS_ENV]["api_key"]

      facebook_uid = request.cookies["#{@fb_api_key}_user"]

      @session_user = User.find_by_facebook_uid(facebook_uid)
      
      if @session_user
        session[:user] = @session_user.id 
        redirect_to @request_path.present? ? @request_path : my_profile_path and return true
      end
    rescue
      raise
    end
    
    redirect_to "/signup_fb/new"
  end
  
end
