class PositionsRemoteController < ApplicationController
  def search
    begin
      @organization = Organization.find(params[:organization_id])
      render :json =>  @organization.positions.all(:conditions => "title LIKE '#{params[:q]}%'", :order => "title ASC", :limit => 20).to_json
    rescue
      render :json => []
    end
  end
end