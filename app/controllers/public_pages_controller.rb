class PublicPagesController < ApplicationController
  
  skip_before_filter :check_authentication
  before_filter :_redirect_if_session_exists
  
  def index
  end
  
  private
  
  def _redirect_if_session_exists
    redirect_to person_path(current_user) if current_user.present?
  end
  
end