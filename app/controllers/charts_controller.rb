class ChartsController < ApplicationController
  
  def chart1
    @user = current_user
    @facts  = ActiveRecord::Base.connection.select_all("SELECT d.datetime AS datetime, yearweek(date(d.datetime)) as yearweek, year(date(d.datetime)) as year, week(date(d.datetime)) AS week, COUNT(p.user_id) AS views FROM date_dims AS d LEFT JOIN profile_views AS p ON(date(d.datetime) = date(p.created_at) AND user_id = #{@user.id} AND viewer_id != #{@user.id}) WHERE date(d.datetime) >= date('#{90.days.ago}') AND date(d.datetime) <= date('#{DateTime.now}') GROUP BY yearweek ORDER BY yearweek")
    render :layout => "/layouts/charts/bar.xml.erb", :template => "/charts/chart1.xml.erb"
  end
end