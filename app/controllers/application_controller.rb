class ApplicationController < ActionController::Base
  # include Authentication
  helper :all
  protect_from_forgery
  filter_parameter_logging :password

  helper_method :current_user
  
  around_filter :catch_exceptions
  before_filter :check_authentication
  
  protected
  
  def check_authentication
    raise SecurityError unless current_user
  end

  def catch_exceptions
    begin
      yield
    rescue SecurityError
      redirect_to :welcome
      return false
    rescue
      raise
    end
  end

  private

  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    @current_user ||= current_user_session && current_user_session.record
  end


end
