class Recruit::RecruitController < ApplicationController
  
  before_filter :check_recruit_mode
  
  def check_recruit_mode
    current_user.settings.recruit_mode = 1 if current_user.settings.recruit_mode == 0
  end
  
end