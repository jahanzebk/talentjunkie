class Recruit::PagesController < Recruit::RecruitController
  
  def index
    @user = current_user
  end
  
end