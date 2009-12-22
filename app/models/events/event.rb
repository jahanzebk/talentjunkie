class Events::Event < ActiveRecord::Base

  belongs_to :subject, :class_name => 'User', :foreign_key => 'subject_id'
  belongs_to :object, :class_name => 'User', :foreign_key => 'object_id'
  
end