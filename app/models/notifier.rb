class Notifier < ActionMailer::Base
  
  helper :notifier
  
  EMAIL_FROM_ADDRESS = "TalentJunkie <noreply@talentjunkie.net>"
  
  def message_notifying_someone_started_following_user(protocol_domain_and_port, follower, followed)
    @protocol_domain_and_port = protocol_domain_and_port
    recipients followed.primary_email
    from EMAIL_FROM_ADDRESS
    subject "#{follower.full_name} is now following you on TalentJunkie!"
    content_type "text/html"
    
    body :follower => follower, :followed => followed
  end
  
  def message_inviting_person(protocol_domain_and_port, invitor, invitee_email_address)
    @protocol_domain_and_port = protocol_domain_and_port
    recipients invitee_email_address
    from EMAIL_FROM_ADDRESS
    subject "#{invitor.full_name} is inviting you to join TalentJunkie!"
    content_type "text/html"
    
    body :invitor => invitor
  end
  
  def message_with_person_profile(protocol_domain_and_port, user, email_address)
    @protocol_domain_and_port = protocol_domain_and_port
    recipients email_address
    from EMAIL_FROM_ADDRESS
    subject "#{user.full_name} has sent you their TalentJunkie profile"
    content_type "text/html"
    
    body :user => user
  end
  
  def message_with_new_password(protocol_domain_and_port, user, password)
    @protocol_domain_and_port = protocol_domain_and_port
    recipients user.primary_email
    from EMAIL_FROM_ADDRESS
    subject "Your TalentJunkie password has been reset"
    content_type "text/html"
    
    body :user => user, :password => password
  end
  
end
