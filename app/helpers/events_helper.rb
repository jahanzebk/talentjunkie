module EventsHelper
  
  def render_event_title(event)
    case event.type.to_s
      when "Events::StartFollowingPeople"
        object_profile_link = link_to event.object.full_name, "/profile/#{event.object_id}"
        "#{event.subject.first_name} is now following #{object_profile_link}"
      when "Events::StartFollowingOrganizations"
        object_profile_link = link_to event.object.name, "/organizations/#{event.object_id}"
        "#{event.subject.first_name} is now following #{object_profile_link}"
      when "Events::NewOpening"
        link_to "#{event.subject.name} is now looking for a #{event.object.position.title}", "/organizations/#{event.subject_id}/openings/#{event.object_id}"
      else
        event.to_s
      end
  end
  
end
