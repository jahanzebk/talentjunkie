class PublicPagesController < ApplicationController
  
  skip_before_filter :check_authentication
  before_filter :_redirect_if_session_exists
  
  def index
  end
  
  def login
    @html_content = render_to_string :partial => "/public_pages/login.haml"
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def _redirect_if_session_exists
    redirect_to person_path(current_user) if current_user.present?
  end
  
end