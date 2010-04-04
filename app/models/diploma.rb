class Diploma < ActiveRecord::Base
  
  belongs_to :degree
  belongs_to :user
  
  validates_presence_of :user, :degree, :from
  
  def degree_attributes(attributes)
  end
  
end