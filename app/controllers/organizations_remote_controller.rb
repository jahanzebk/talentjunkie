class OrganizationsRemoteController < ApplicationController
  def search
    render :json => Organization.all(:conditions => "name LIKE '#{params[:q]}%'", :order => "name ASC", :limit => 20).to_json
  end
end