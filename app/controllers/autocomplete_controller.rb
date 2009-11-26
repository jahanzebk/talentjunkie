class AutocompleteController < ApplicationController
  def cities
    q = params[:q]
    
    city = q.split(/,/)[0].strip if q.split(/,/)[0]
    country = q.split(/,/)[1].strip if q.split(/,/)[1]
    cities = ActiveRecord::Base.connection.select_all("SELECT cities.id AS id, CONCAT(cities.name, ', ',  countries.name) AS name FROM cities LEFT JOIN countries ON(cities.country_id = countries.id) WHERE cities.name LIKE '#{city}%' AND countries.name LIKE '#{country}%' ORDER BY cities.name ASC, countries.name ASC LIMIT 5")
    render :json => cities.to_json
  end
  
  def organizations
    render :json => ActiveRecord::Base.connection.select_all("SELECT id, name FROM organizations WHERE name LIKE '#{params[:q]}%' ORDER BY name ASC LIMIT 20").to_json
  end
  
  def positions
    begin
      render :json => ActiveRecord::Base.connection.select_all("SELECT id, title AS name FROM positions WHERE positions.organization_id = #{params[:scope_as_id]} AND title LIKE '#{params[:q]}%' ORDER BY title ASC LIMIT 20").to_json
    rescue
      render :json => []
    end
  end
end