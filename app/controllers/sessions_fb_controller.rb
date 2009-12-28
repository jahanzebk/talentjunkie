class SessionsFbController < ApplicationController
  
  skip_before_filter :check_authentication

  def create
    begin
      @request_path = session[:request_path]
      reset_session
      
      @fb_config = YAML::load(File.open("#{RAILS_ROOT}/config/facebooker.yml"))
      @fb_api_key = @fb_config[RAILS_ENV]["api_key"]

      @session_user = User.find_by_facebook_uid(request.cookies["#{@fb_api_key}_user"])
      
      if @session_user
        session[:user] = @session_user.id 
        redirect_to @request_path.present? ? @request_path : person_path(@session_user) and return true
      else
        redirect_to :welcome
      end
    rescue
      raise
    end
    
    redirect_to "/signup_fb/new"
  end
  
end
