class CommunitiesController < ApplicationController

  def index
    @title = "communities"
    @communities = Community.all
  end
  
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
    @events = @community.feed(10)
  end
  
  def join
    respond_to do |format|
      begin
        @community = Community.find(params[:id])
        CommunitiesUser.create!({:community_id => @community.id, :user_id => current_user.id, :since => DateTime.now.utc}) unless current_user.has_joined?(@community)
        
        # begin
        #   Notifier.deliver_message_notifying_someone_started_following_user(_protocol_domain_and_port, current_user, @user_to_follow)
        # rescue
        # end

        Events::JoinedCommunity.create!({:subject_id => current_user.id, :object_id => @community.id})
        
        format.json{ render :json => :ok }
      rescue
        raise
        format.json{ render :json => {}, :status => 406 }
      end
    end
  end
  
end