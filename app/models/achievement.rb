class Achievement < ActiveRecord::Base
  has_many :steps, :class_name => "AchievementStep", :order => "`order` ASC"
  
  def completeness_for(user)
    number_of_steps = steps.size
    number_of_steps_achieved = user.steps_for_achievement(self).size
    (number_of_steps_achieved.to_f * 100) / number_of_steps
  end
end