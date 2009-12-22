class Events::StartFollowingPeople < Events::Event
  
  def to_s
    "#{self.subject.first_name} is now following %a=#{self.object.full_name}"
  end
  
end