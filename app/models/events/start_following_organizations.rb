class Events::StartFollowingOrganizations < Events::Event
  belongs_to :object, :class_name => 'Organization', :foreign_key => 'object_id'
end