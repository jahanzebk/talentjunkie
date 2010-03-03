# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def render_guide(name)
    html = ''
    begin
      guide = Guide.find_by_name(name.to_s)
      html = render_guide_to_string(guide) if guide_is_queued?(guide)
    rescue
      raise
    end
    
    html
  end
  
  def render_guide_to_string(guide)
    unqueue_guide(guide)
    render_to_string :template => "/guides/after_signup.haml", :layout => false
  end
  
  def controller_namespace_is?(namespace)
    !controller.class.to_s.match(/^#{namespace}::/i).nil?
  end

  def link_to_remote_with_local_response_handling(name, options = {}, html_options = nil)
    options[:success] = "handle_success(request)" unless options[:success]
    options[:failure] = "handle_failure(request)" unless options[:failure]
    link_to_remote name, options, html_options
  end

  def to_view_date(datetime)
    datetime.strftime("%B %d, %Y")
  end
  def link_over_ajax(link, href, handle = "handle_request")
    "<a href='#{href}' onclick='#{handle}(this); return false;'>#{link}</a>"
  end
  
  def button_over_ajax(link, href)
    "<a class='button' href='#{href}' onclick='handle_request(this); return false;'>#{link}</a>"
  end
  
  def ajax_error_message
    "Ooopps! This is embarrassing: an error occurred and this was the best we came up with... Please try again."
  end

  def my_newsfeed_path
    "#{person_path(current_user)}/newsfeed"
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
    if @protocol_domain_and_port.present?
      @protocol_domain_and_port
    else
      protocol = request.protocol
      domain = request.env["SERVER_NAME"]
      port = (request.port and request.port != 80 ? ":#{request.port}" : "")
      "#{protocol}#{domain}#{port}"
    end
  end
  
  protected
  
  
  def url_shortener(full_uri)
    mapper = UrlMapper.find_by_original_url(full_uri)
    
    if mapper
      string = mapper.short_url
    else
      string = "/"
      5.times { string << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
      begin
        UrlMapper.create!({:short_url => string, :original_url => full_uri})
      rescue
      end
    end
    "#{APP_CONFIG['url_shortener']}#{string}"
  end
  
end
