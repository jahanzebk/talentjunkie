class Manage::MyJobApplicationsController < ApplicationController

  def index
    current_user.settings.update_attribute(:apply_mode ,1)
    @user = current_user
  end
  
end