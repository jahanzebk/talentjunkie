class Notifier < ActionMailer::Base
  
  def message_notifying_someone_started_following_user(follower, followed)
    recipients followed.primary_email
    from "TalentJunkie <noreply@talentjunkie.co.uk>"
    subject "#{follower.full_name} is now following you on TalentJunkie!"
    content_type "text/html"
    
    body :follower => follower, :followed => followed
  end
  
  def message_inviting_person(invitor, invitee_email_address)
    recipients invitee_email_address
    from "TalentJunkie <noreply@talentjunkie.co.uk>"
    subject "#{invitor.full_name} is inviting you to join TalentJunkie!"
    content_type "text/html"
    
    body :invitor => invitor
  end
  
end
