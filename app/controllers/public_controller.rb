class PublicController < ActionController::Base

  layout 'application'
  
  helper :all
  # protect_from_forgery

  helper_method :current_user

  before_filter :redirect_if_session_exists, :init
  
  def init
    @fb_config = YAML::load(File.open("#{RAILS_ROOT}/config/facebooker.yml"))
    @fb_api_key = @fb_config[RAILS_ENV]["api_key"]
    @fb_secret_key = @fb_config[RAILS_ENV]["secret_key"]
  end
  
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
