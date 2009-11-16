class PublicController < ActionController::Base

  layout 'application'
  
  helper :all
  protect_from_forgery

  helper_method :current_user
  
  private

  def current_user
    nil
  end


end
