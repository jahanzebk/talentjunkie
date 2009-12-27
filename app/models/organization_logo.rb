class OrganizationLogo < ActiveRecord::Base

  belongs_to :organization

  has_attachment :storage => :file_system, 
                 :size => (1..256.kilobytes),
                 :path_prefix => 'public/images/organizations'
                 

  validates_as_attachment
  
end