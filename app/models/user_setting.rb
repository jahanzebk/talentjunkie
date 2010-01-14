class UserSetting < ActiveRecord::Base
  belongs_to :user
  
  def is_in_recruit_mode?
    recruit_mode == 1
  end
end
