class UserService < ModelService

  def initialize(serviceable)
    type = serviceable.class.to_s
    @var  = "@user"
    self.instance_variable_set(@var, serviceable)
  end
  
  def profile_views_by_day_for_the_last_30_days
    ActiveRecord::Base.connection.select_all("SELECT date(d.datetime) AS date, COUNT(p.user_id) AS views FROM date_dims AS d LEFT JOIN profile_views AS p ON(date(d.datetime) = date(p.created_at) AND user_id = #{@user.id} AND viewer_id != #{@user.id}) WHERE date(d.datetime) >= date('#{30.days.ago}') AND date(d.datetime) <= date('#{DateTime.now}') GROUP BY date ORDER BY d.datetime")
  end

  def profile_views
    Stats::ProfileView.count(:conditions => "user_id = #{@user.id} AND (viewer_id != #{@user.id} OR viewer_id IS NULL)")
  end
  
  def unique_profile_views
    Stats::ProfileView.count(:viewer_id, :conditions => "user_id = #{@user.id} AND (viewer_id != #{@user.id} OR viewer_id IS NULL)")
  end
  
  # views by
    
    # views over time (last 12 months)
    
    # geographical location as map
    
    # people with x years experience
      # 5
      # 5 to 15
      # 15 to 25
      # 25 +
    # number of followers
      # 0 to 100
      # 100 to 500
      # 500 to 5000
      # 5000 +
    # top 10 organizations people who looked at your profile belong to
    # top 10 industries organizations people who looked at your profile belong to
  
end