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
  
  def ajax_error_message
    "Ooopps! This is embarrassing: an error occurred and this was the best we came up with... Please try again."
  end
  
  def my_profile_path
    current_user.present? ? person_path(current_user) : "/"
  end
  
  def my_recruitment_dashboard_path
    "/recruit"
  end
  
  def my_settings_path
    "#{person_path(current_user)}/settings"
  end
  
  def person_url(user)
    protocol = request.protocol
    domain = request.domain
    port = request.port ? ":#{request.port}" : ""
    "#{protocol}#{domain}#{port}#{person_path(user)}"
  end
  
  def person_path(user)
    user.handle.present? ? "/people/#{user.handle}" : "/people/#{user.id}"
  end
  
  def person_id_path(user)
    "/people/#{user.id}"
  end
  
  def organization_url(organization)
    protocol = request.protocol
    domain = request.domain
    port = request.port ? ":#{request.port}" : ""
    "#{protocol}#{domain}#{port}#{organization_path(organization)}"
  end
  
  def organization_path(organization)
    organization.handle.present? ? "/organizations/#{organization.handle}" : "/organizations/#{organization.id}"
  end
  
  def opening_path(contract)
    "#{organization_path(contract.position.organization)}/openings/#{contract.id}"
  end
  
  def opening_url(contract)
    "#{organization_url(contract.position.organization)}/openings/#{contract.id}"
  end
  
  def to_redcloth(redcloth_content)
    redcloth = RedCloth.new(redcloth_content || "")
    redcloth.sanitize_html = true
    redcloth.to_html(:textile)
  end
end
