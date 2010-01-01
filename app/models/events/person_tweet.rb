class Events::PersonTweet < Events::Event
  belongs_to :subject, :class_name => 'User', :foreign_key => 'subject_id'
  
  def to_s
    content
  end
end