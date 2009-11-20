class SearchRemoteController < ApplicationController
  def search
    begin
      organizations = Organization.all(:conditions => "name LIKE '#{params[:q]}%'", :order => "name ASC", :limit => 20)
      
      results = []
      organizations .each do |organization|
        r = SearchResult.new
        r.name = organization.name
        r.industry = organization.industry.name if organization.industry
        r.url = url_for(organization)
        results << r
      end
      render :json =>  results.to_json
    rescue
      raise
      render :json => []
    end
  end
end

class SearchResult
  attr_accessor :name
  attr_accessor :industry
  attr_accessor :url
  attr_accessor :entity
end