class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  
  helper :all

  #protect_from_forgery
  filter_parameter_logging :password

  helper_method :current_user
  
  before_filter :init
  around_filter :catch_exceptions
  # before_filter :check_fb_session, :check_authentication
  
  def init
    @fb_config = YAML::load(File.open("#{RAILS_ROOT}/config/facebooker.yml"))
    @fb_api_key = @fb_config[RAILS_ENV]["api_key"]
    @fb_secret_key = @fb_config[RAILS_ENV]["secret_key"]
  end
  
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

  def collect_errors_for(*args)
    errors = {}
    args.each do |model|
      errors[model.class.name.underscore.to_sym] = model.errors if model and model.errors
    end
    errors
  end

  private

  # def current_user_session
  #   @current_user_session ||= UserSession.find
  # end
  # 
  def current_user
    @current_user ||= User.find(session[:user])
  end


end
