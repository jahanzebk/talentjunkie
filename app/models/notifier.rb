class Notifier < ActionMailer::Base
  
  def message_notifying_someone_started_following_user(follower, followed)
    recipients followed.primary_email
    from "TalentJunkie <noreply@talentjunkie.co.uk>"
    subject "#{follower.full_name} is now following you on TalentJunkie!"
    content_type "text/html"
    
    body :follower => follower, :followed => followed
  end
  
end
