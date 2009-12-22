class Events::UpdatedProfile < Events::Event
  
  def to_s
    "#{self.subject.first_name} updated their profile."
  end
  
end