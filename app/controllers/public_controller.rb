class PublicController < ActionController::Base

  layout 'application'
  
  helper :all
  protect_from_forgery

  helper_method :current_user

  before_filter :redirect_if_session_exists
  
  protected
  
  def collect_errors_for(*args)
    errors = {}
    args.each do |model|
      errors[model.class.name.underscore.to_sym] = model.errors if model and model.errors
    end
    errors
  end
  
  private

  def redirect_if_session_exists
    redirect_to :my_profile if session[:user]
  end

  def current_user
    nil
  end


end
