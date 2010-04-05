class Community < ActiveRecord::Base
  belongs_to :theme
  has_and_belongs_to_many :openings
  has_and_belongs_to_many :users
  
end