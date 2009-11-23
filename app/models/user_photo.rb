class UserPhoto < ActiveRecord::Base

  belongs_to :user

  has_attachment :storage => :file_system, 
                 :size => (1..256.kilobytes),
                 :path_prefix => 'public/images/users'
                 

  validates_as_attachment
  
end