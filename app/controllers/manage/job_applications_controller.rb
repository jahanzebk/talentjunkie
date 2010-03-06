class Manage::JobApplicationsController < ApplicationController

  def index
    current_user.settings.update_attribute(:recruit_mode ,1)
    @title = "manage your job applications"
  end
  
end