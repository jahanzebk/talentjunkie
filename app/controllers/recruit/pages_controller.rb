class Manage::PagesController < Recruit::RecruitController
  
  def index
    current_user.settings.update_attribute(:recruit_mode ,1)
    @user = current_user
  end
  
end