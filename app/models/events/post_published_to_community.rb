class Events::PostPublishedToCommunity < Events::Event

  belongs_to :subject, :class_name => 'ExternalFeedEntry', :foreign_key => 'subject_id'
  belongs_to :object, :class_name => 'Community', :foreign_key => 'object_id'

  def initialize(*args)
    super(*args)
    self[:subject_type] = "ExternalFeedEntry"
    self[:object_type] = "Community"
  end

end