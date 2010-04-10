class Admin::ExternalFeedEntryCommunitiesController < AdminController

  def index
    @entry = ExternalFeedEntry.find(params[:entry_id])
    json = {'communities' => @entry.published_to_communities_with_publish_count}.to_json
    json.gsub!(/null/, '{}')
    render :json => json
  end
  
  def create
    begin
      @entry = ExternalFeedEntry.find(params[:entry][:id])
      
      unless @community = Community.find_by_name(params[:entry][:community_attributes][:name])
        @community = Community.create!(params[:entry][:community_attributes])
      end
      
      raise ActiveRecord::ActiveRecordError.new if @entry.communities.include?(@community)
      
      @link = ExternalFeedEntriesCommunity.create!({:external_feed_entry_id => @entry.id, :community_id => @community.id})
      @entry.update_attribute(:classified, 1)
      
      render :json => @community, :status => 201
    rescue ActiveRecord::ActiveRecordError
      render :json => :ok, :status => 406
    rescue
      render :json => :ok, :status => 406
    end
  end

  def publish
    begin
      @entry = ExternalFeedEntry.find(params[:entry_id])
      @community = Community.find(params[:id])

      ActiveRecord::Base.connection.execute("UPDATE external_feed_entries_communities SET publish_count = publish_count + 1 WHERE external_feed_entry_id = #{@entry.id} AND community_id = #{@community.id}")
      assoc = ExternalFeedEntriesCommunity.find_by_assoc(@entry, @community)
      
      Events::PostPublishedToCommunity.create!({:object_id => @community.id, :subject_id => @entry.id})
      render :json => "({'entry_id': #{@entry.id}, 'community_id': #{@community.id}, 'count': #{assoc.publish_count}})", :status => 201
    rescue
      render :json => {}, :status => 406
    end
  end
  
end