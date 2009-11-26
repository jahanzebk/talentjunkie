class UserDetail < ActiveRecord::Base
  belongs_to :user
  
  def city
    City.find(self[:cities_id])
  end
end