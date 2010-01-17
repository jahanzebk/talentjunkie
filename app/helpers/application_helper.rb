# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def controller_namespace_is?(namespace)
    !controller.class.to_s.match(/^#{namespace}::/i).nil?
  end

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
    "#{_protocol_domain_and_port}#{person_path(user)}"
  end
  
  def person_path(user)
    user.handle.present? ? "/people/#{user.handle}" : "/people/#{user.id}"
  end
  
  def person_id_path(user)
    "/people/#{user.id}"
  end
  
  def organization_url(organization)
    "#{_protocol_domain_and_port}#{organization_path(organization)}"
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
  
  def word_frequency(text)
    words = text.split(/[^a-zA-Z]/)
    freqs = Hash.new(0)
    words.each { |word| freqs[word] += 1 }
    freqs = freqs.sort_by {|x,y| y }
    freqs.reverse!
    
    freqs
  end
  
  def _protocol_domain_and_port
    protocol = request.protocol
    domain = request.env["SERVER_NAME"]
    port = (request.port and request.port != 80 ? ":#{request.port}" : "")
    "#{protocol}#{domain}#{port}"
  end
  
  protected
  
  
  def url_shortener(full_uri)
    mapper = UrlMapper.find_by_original_url(full_uri)
    
    if mapper
      string = mapper.short_url
    else
      string = "/"
      5.times { string << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
      UrlMapper.create!({:short_url => string, :original_url => full_uri})
    end
    "#{APP_CONFIG['url_shortener']}/#{string}"
  end
  
end
