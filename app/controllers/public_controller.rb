class PublicController < ActionController::Base
  include ExceptionNotifiable
  include ApplicationHelper
  
  layout 'application'
  
  helper :all
  helper_method :render_to_string, :guide_is_queued?, :unqueue_guide
  # protect_from_forgery

  helper_method :current_user

  before_filter :redirect_if_session_exists
  before_filter :init
  
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
    redirect_to my_profile_path if session[:user]
  end

  def current_user
  end



  def queue_guide_by_name(name)
    queue_guide(Guide.find_by_name(name.to_s))
  end
  
  def queue_guide(guide)
    begin
      guides = []
      guides = cookies[:guides].split('*') if cookies[:guides]
      
      if guide and !guides.include?(guide.name.to_s)
        guides.push(guide.name)
        cookies[:guides] = guides.join('*')
      end
    rescue
      raise
    end
  end
  
  def unqueue_guide(guide)
    begin
      guides = []
      guides = cookies[:guides].split('*') if cookies[:guides]
      guides.delete(guide.name)
      cookies[:guides] = guides.join('*')
    rescue
      raise
    end
  end

  def guide_is_queued?(guide)
    cookies[:guides].split('*').include?(guide.name.to_s) if cookies[:guides]
  end
  
end
