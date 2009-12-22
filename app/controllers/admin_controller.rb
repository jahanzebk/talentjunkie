class AdminController < ApplicationController
  
  before_filter :ensure_user_is_admin
  
  def init
    @title = "admin"
  end
      
  def ensure_user_is_admin
    raise SecurityError unless current_user.is_admin?
  end
end
