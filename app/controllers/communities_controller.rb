class CommunitiesController < ApplicationController
  
  def show
    @community = Community.find_by_name!(params[:id])
    @title = @community.name
    @theme = @community.theme.name
  end
  
  def jobs
    @community = Community.find_by_name(params[:id])
    @title = "#{@community.name} jobs"
    @openings = @community.openings.active
  end
  
  def newsfeed
    @community = Community.find_by_name(params[:id])
    @title = "#{@community.name} community newsfeed"
    @events
  end
  
end