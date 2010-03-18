module GuidesHelper
  
  def render_guide(name)
    html = ''
    begin
      guide = Guide.find_by_name!(name.to_s)
      
      if guide_is_queued_in_session?(guide)
        html = render_to_string :template => "/guides/#{guide.template}.haml", :layout => false
        unqueue_guide_from_session(guide)
      elsif guide_is_queued_in_db?(guide)
        html = render_to_string :template => "/guides/#{guide.template}.haml", :layout => false
        unqueue_guide_from_db(guide)
      end
    rescue
    end
    
    html
  end
  
end