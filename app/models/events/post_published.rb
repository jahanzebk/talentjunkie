class Events::PostPublished < Events::Event

  belongs_to :subject, :class_name => 'ExternalFeedEntry', :foreign_key => 'subject_id'
  belongs_to :object, :class_name => 'Organization', :foreign_key => 'object_id'

  def initialize(*args)
    super(*args)
    self[:subject_type] = "ExternalFeedEntry"
    self[:object_type] = "Organization"
  end

end