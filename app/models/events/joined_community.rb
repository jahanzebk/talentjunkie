class Events::JoinedCommunity < Events::Event
  belongs_to :subject, :class_name => 'User', :foreign_key => 'subject_id'
  belongs_to :object, :class_name => 'Community', :foreign_key => 'object_id'
  
  def initialize(*args)
    super(*args)
    self[:subject_type] = "User"
    self[:object_type] = "Community"
  end
  
  def to_s
    content
  end
end