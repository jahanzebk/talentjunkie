class PublicController < ActionController::Base

  layout 'application'
  
  helper :all
  protect_from_forgery

  helper_method :current_user

  before_filter :redirect_if_session_exists
  
  private

  def redirect_if_session_exists
    current_user_session = UserSession.find
    redirect_to :my_profile if current_user_session.present?
  end

  def current_user
    nil
  end


end
