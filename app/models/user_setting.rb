class UserSetting < ActiveRecord::Base
  belongs_to :user
  belongs_to :theme
  
  def is_in_recruit_mode?
    recruit_mode == 1
  end
  
  def is_in_apply_mode?
    apply_mode == 1
  end
  
  def theme_name
    theme.present? ? theme.name : "default"
  end
end
