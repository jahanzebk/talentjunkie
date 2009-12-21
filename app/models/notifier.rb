class Notifier < ActionMailer::Base
  
  def message_to_followed(follower, followed)
    recipients followed.primary_email
    from "talentjunkie.co.uk <noreply@talentjunkie.co.uk>"
    subject "#{follower.full_name} is now following you on TalentJunkie!"
    content_type "text/html"
    
    body :follower => follower, :followed => followed
  end
  
end
