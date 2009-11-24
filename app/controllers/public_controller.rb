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
    current_user_session = UserSession.find
    redirect_to :my_profile if current_user_session.present?
  end

  def current_user
    nil
  end


end
