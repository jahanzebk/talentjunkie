class OrganizationOffice < ActiveRecord::Base
  belongs_to :address
  
  validates_presence_of :name, :organization_id, :address_id
end
