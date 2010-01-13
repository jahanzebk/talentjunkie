class UserFeedService < ModelService

  def initialize(serviceable)
    type = serviceable.class.to_s
    @var  = "@user"
    self.instance_variable_set(@var, serviceable)
  end
  
  def feed(limit = nil)
    
    limit_clause = "LIMIT #{limit}" unless limit.nil?
    
    sql =<<SQL
        (SELECT 
            events.* FROM events 
            LEFT JOIN following_people ON (
                                              (events.subject_type = "User" AND events.subject_id = following_people.followed_user_id) 
                                              /* OR
                                              (events.object_type = "User" AND events.object_id = following_people.followed_user_id) */
                                          )
            WHERE
              following_people.follower_user_id = #{@user.id} 
              OR events.subject_id = #{@user.id}
        )
        UNION
        (SELECT 
            events.* FROM events 
            LEFT JOIN following_organizations ON(events.object_type = "Organization" AND events.object_id = following_organizations.organization_id) 
            WHERE 
              following_organizations.user_id = #{@user.id}
        ) 
        ORDER BY 
          created_at DESC
        #{limit_clause}
SQL
    
    Events::Event.find_by_sql(sql)
  end

end