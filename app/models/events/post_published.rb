class Events::PostPublished < Events::Event
  belongs_to :subject, :class_name => 'Organization', :foreign_key => 'subject_id'
  belongs_to :object, :class_name => 'ExternalFeedEntry', :foreign_key => 'object_id'
end