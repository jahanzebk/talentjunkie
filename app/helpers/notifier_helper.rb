module NotifierHelper
  
  def person_url(user)
    "#{@protocol_domain_and_port}#{person_path(user)}"
  end
  
  def person_path(user)
    user.handle.present? ? "/people/#{user.handle}" : "/people/#{user.id}"
  end
end