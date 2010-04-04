class Degree < ActiveRecord::Base
  
  include ActiveRecord::CustomNestedAttributes
  
  belongs_to :organization
  validates_presence_of :organization
  
  custom_accepts_nested_attributes_for :organization, :key => 'name'
  
end