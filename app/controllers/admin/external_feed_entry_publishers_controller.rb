class Admin::ExternalFeedEntryPublishersController < AdminController

  def index
    @entry = ExternalFeedEntry.find(params[:entry_id])
    json = {'organizations' => @entry.published_to}.to_json
    json.gsub!(/null/, '{}')
    render :json => json
  end
  
  def create
    begin
      @entry = ExternalFeedEntry.find(params[:entry_id])
      @organization = Organization.find_or_create_organization_by_name(params["entry_#{@entry.id}_organization"])
    
      raise ActiveRecord::ActiveRecordError.new if @entry.organizations.include?(@organization)
      @link = ExternalFeedEntriesOrganization.create!({:external_feed_entry_id => @entry.id, :organization_id => @organization.id})
      @entry.update_attribute(:classified, 1)
      
      render :json => @organization, :status => 201
    rescue ActiveRecord::ActiveRecordError
      render :json => :ok, :status => 406
    rescue
      render :json => :ok, :status => 406
    end
  end

  def publish
    begin
      @entry = ExternalFeedEntry.find(params[:entry_id])
      @organization = Organization.find(params[:id])

      ActiveRecord::Base.connection.execute("UPDATE external_feed_entries_organizations SET publish_count = publish_count + 1 WHERE external_feed_entry_id = #{@entry.id} AND organization_id = #{@organization.id}")
      assoc = ExternalFeedEntriesOrganization.find_by_assoc(@entry, @organization)
      
      Events::PostPublished.create!({:object_id => @organization.id, :subject_id => @entry.id})
      render :json => "({'entry_id': #{@entry.id}, 'organization_id': #{@organization.id}, 'count': #{assoc.publish_count}})", :status => 201
    rescue
      render :json => {}, :status => 406
    end
  end
  
  def destroy
    begin
      @entry = ExternalFeedEntry.find(params[:entry_id])
      @organization = Organization.find(params[:id])

      ActiveRecord::Base.connection.execute("DELETE FROM external_feed_entries_organizations WHERE external_feed_entry_id = #{@entry.id} AND organization_id = #{@organization.id}")
      render :json => "({'entry_id': #{@entry.id}, 'organization_id': #{@organization.id}})", :status => 201
    rescue
      render :json => {}, :status => 406
    end
  end
end