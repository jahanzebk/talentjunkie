class Degree < ActiveRecord::Base
  belongs_to :organization
  
  validates_presence_of :organization_id 
end