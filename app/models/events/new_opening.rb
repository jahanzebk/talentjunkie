class Events::NewOpening < Events::Event
  belongs_to :subject, :class_name => 'Organization', :foreign_key => 'subject_id'
  belongs_to :object, :class_name => 'Contract', :foreign_key => 'object_id'
end