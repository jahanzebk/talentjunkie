class SearchRemoteController < ApplicationController
  def search
    begin
      results = []

      User.all(:conditions => "CONCAT(first_name, ' ', last_name) LIKE '%#{params[:q]}%'", :order => "first_name ASC", :limit => 10).each do |person|
        results << SearchResult.new(person, person.full_name, person.title, "/profile/#{person.id}")
      end

      Organization.all(:conditions => "name LIKE '%#{params[:q]}%'", :order => "name ASC", :limit => 10).each do |organization|
        industry = organization.industry ? organization.industry.name : ""
        results << SearchResult.new(organization, organization.name, industry, url_for(organization))
      end
      
      render :json =>  results.to_json
    rescue
      raise
      render :json => []
    end
  end
  
  def autocomplete_cities
    q = params[:q]
    
    city = q.split(/,/)[0].strip if q.split(/,/)[0]
    country = q.split(/,/)[1].strip if q.split(/,/)[1]
    cities = ActiveRecord::Base.connection.select_all("SELECT countries.id AS country_id, countries.name AS country_name, cities.id AS city_id, cities.name AS city_name FROM cities LEFT JOIN countries ON(cities.country_id = countries.id) WHERE cities.name LIKE '#{city}%' AND countries.name LIKE '#{country}%' ORDER BY cities.name ASC, countries.name ASC LIMIT 5")
    render :json => cities.to_json
  end
  
end

class SearchResult
  attr_accessor :title
  attr_accessor :subtitle
  attr_accessor :url
  attr_accessor :entity
  
  def initialize(entity, title, subtitle, url)
    @title = title
    @subtitle = subtitle
    @entity = entity
    @url = url
  end
end