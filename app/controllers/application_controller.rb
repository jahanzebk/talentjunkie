class ApplicationController < ActionController::Base
  # include Authentication
  helper :all
  protect_from_forgery
  filter_parameter_logging :password

  helper_method :current_user
  
  protected
  
  def init
  end
  
  private

  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    @current_user ||= current_user_session && current_user_session.record
  end


end
