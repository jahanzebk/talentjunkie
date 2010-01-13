class OrganizationFeedService < ModelService

  def feed(limit = nil)
    Events::Event.all(:conditions => "object_type = 'Organization' AND object_id = #{@organization.id}", :order => "created_at DESC", :limit => limit)
  end

end