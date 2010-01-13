class Admin::ExternalFeedEntryPublishersController < AdminController
  
  def create
    begin
      @entry = ExternalFeedEntry.find(params[:entry_id])
      organization_id = params["entry_#{@entry.id}_organization"][:id]
      @organization = Organization.find(organization_id)
    
      raise ActiveRecord::ActiveRecordError.new if @entry.organizations.include?(@organization)
      @link = ExternalFeedEntriesOrganization.create!({:external_feed_entry_id => @entry.id, :organization_id => @organization.id})
      # render :json => {:entry => @entry, :organization => @organization}.to_json, :status => 200
      render :json => {:url => admin_external_feed_entries_path(@entry.external_feed)}, :status => 201
    rescue ActiveRecord::ActiveRecordError
      render :json => :ok, :status => 406
    rescue
      render :json => :ok, :status => 406
      # render :json => collect_errors_for(@organization, @position, @contract).to_json, :status => 406
    end
  end

  def publish
    begin
      @entry = ExternalFeedEntry.find(params[:entry_id])
      @organization = Organization.find(params[:id])

      ActiveRecord::Base.connection.execute("UPDATE external_feed_entries_organizations SET publish_count = publish_count + 1 WHERE external_feed_entry_id = #{@entry.id} AND organization_id = #{@organization.id}")
      Events::PostPublished.create!({:subject_id => @organization.id, :object_id => @entry.id})
      
      redirect_to admin_external_feed_entries_path(@entry.external_feed)
    rescue
      raise
    end
  end
  
  def destroy
    @entry = ExternalFeedEntry.find(params[:entry_id])
    ActiveRecord::Base.connection.execute("DELETE FROM external_feed_entries_organizations WHERE external_feed_entry_id = #{@entry.id} AND organization_id = #{params[:id]}")
    redirect_to admin_external_feed_entries_path(@entry.external_feed)
  end
end