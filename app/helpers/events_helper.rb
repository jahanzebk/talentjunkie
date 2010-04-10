module EventsHelper
  
  def render_event_title(event)
    case event.type.to_s
      when "Events::StartFollowingPeople"
        object_profile_link = link_to event.object.full_name, "/people/#{event.object_id}"
        "#{event.subject.first_name} is now following #{object_profile_link}"
      when "Events::StartFollowingOrganizations"
        object_profile_link = link_to event.object.name, "/organizations/#{event.object_id}"
        "#{event.subject.first_name} is now following #{object_profile_link}"
      when "Events::NewOpening"
        link_to "#{event.subject.name} is now looking for a #{event.object.position.title}", "/organizations/#{event.subject_id}/openings/#{event.object_id}"
      when "Events::JoinedCommunity"
        community_link = link_to "#{event.object.name} community", community_path(event.object)
        "#{event.subject.first_name} joined the #{community_link}"
      when "Events::PostPublished"
        html =  "<span class='from'>#{event.subject.external_feed.title} </span>"
        html += link_to event.subject.title, event.subject.url, :target => "_blank"
      else
        event.to_s
      end
  end

  def render_sharing_for(event)
    case event.type.to_s
      when "Events::PostPublished"
        html = "<br />"
        html += "<div class='actions'>"
        status = CGI::escape("#{truncate(event.subject.title, :length => 110)} #{url_shortener(event.subject.url)}")
        html += link_to "tweet this entry", "http://twitter.com/?status=#{status}", :target => "_blank"
        html += "</div><br />"
      when "Events::PersonTweet"
        html = "<br />"
        html += "<div class='actions'>"
        status = CGI::escape("RT @#{event.subject.twitter_handle} #{event.content}")
        html += link_to "retweet", "http://twitter.com/?status=#{status}", :target => "_blank"
        html += "</div><br />"
      else
        ""
      end
  end

  def get_class_by_event_type(event)
    case event.type.to_s
      when "Events::PersonTweet"
        "tweet"
      else
        ""
      end
  end

  def get_icon_by_event_type(event)
    case event.type.to_s
      when "Events::PersonTweet"
        "/images/twitter_t_logo_outline.png"
      else
        "/images/twitter_t_logo_outline.png"
      end
  end
  
end
