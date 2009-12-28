# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def to_view_date(datetime)
    datetime.strftime("%B %d, %Y")
  end
  def link_over_ajax(link, href)
    "<a href='#{href}' onclick='handle_request(this); return false;'>#{link}</a>"
  end
  
  def button_over_ajax(link, href)
    "<a class='button' href='#{href}' onclick='handle_request(this); return false;'>#{link}</a>"
  end
  
  def my_profile_path
    link_to_person(current_user)
  end
  
  def my_settings_path
    "#{link_to_person(current_user)}/settings"
  end
  
  def link_to_person(user)
    user.handle.present? ? "/people/#{user.handle}" : "/people/#{user.id}"
  end
end
