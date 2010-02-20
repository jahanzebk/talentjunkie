class SessionsController < ApplicationController

  skip_before_filter :check_authentication
  
  def new
  end
  
  def create
    begin
      @request_path = session[:request_path]
      reset_session
      @session_user = SimpleUser.authenticate(params[:primary_email], params[:password])
      
      if @session_user
        session[:user] = @session_user.id 
        redirect_to @request_path.present? ? @request_path : person_path(@session_user) and return true
      else
        redirect_to :welcome
      end
    rescue SecurityError => e
      flash[:error] = 'The email address or password you provided does not match our records. Please provide a valid email and password.'
    rescue
      raise
    end
    
    redirect_to :welcome
  end
  
  def destroy
    @session_user = nil
    session[:user] = nil
    reset_session
    redirect_to :welcome
  end

end
