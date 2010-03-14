class PublicPagesController < ApplicationController
  
  skip_before_filter :check_authentication
  before_filter :_redirect_if_session_exists, :except => [:vision]
  
  def index
  end
  
  def login
    @html_content = render_to_string :partial => "/public_pages/login.haml"
    respond_to do |format|
      format.js
    end
  end
  
  def please_login
    @html_content = render_to_string :partial => "/users/please_login.haml"
    respond_to do |format|
      format.js {render :template => "/users/please_login.rjs"}
    end
  end
  
  def vision
  end
  
  private
  
  def _redirect_if_session_exists
    redirect_to person_path(current_user) if current_user.present?
  end
  
end