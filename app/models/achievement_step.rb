class AchievementStep < ActiveRecord::Base
  belongs_to :achievements
  has_and_belongs_to_many :users
end