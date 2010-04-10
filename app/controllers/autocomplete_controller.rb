class AutocompleteController < ApplicationController
  def cities
    q = params[:q]
    if q.size > 2
      city = q.split(/,/)[0].strip if q.split(/,/)[0]
      country = q.split(/,/)[1].strip if q.split(/,/)[1]
      cities = ActiveRecord::Base.connection.select_all("SELECT cities.id AS id, CONCAT(cities.name, ', ',  countries.name) AS name FROM cities LEFT JOIN countries ON(cities.country_id = countries.id) WHERE cities.name LIKE '#{city}%' AND countries.name LIKE '#{country}%' ORDER BY cities.name ASC, countries.name ASC LIMIT 5")
      render :json => cities.to_json
    else
      render :json => [].to_json
    end
  end
  
  def organizations
    render :json => ActiveRecord::Base.connection.select_all("SELECT id, name FROM organizations WHERE name LIKE '#{params[:q]}%' ORDER BY name ASC LIMIT 20").to_json
  end
  
  def communities
    render :json => ActiveRecord::Base.connection.select_all("SELECT id, name FROM communities WHERE name LIKE '#{params[:q]}%' ORDER BY name ASC LIMIT 20").to_json
  end
  
  def positions
    begin
      organization = Organization.find_by_name(params[:scope_as_value])
      render :json => ActiveRecord::Base.connection.select_all("SELECT id, title AS name FROM positions WHERE positions.organization_id = #{organization.id} AND title LIKE '#{params[:q]}%' ORDER BY title ASC LIMIT 20").to_json
    rescue
      raise
      render :json => []
    end
  end
  
  def degrees
    begin
      organization = Organization.find_by_name(params[:scope_as_value])
      render :json => ActiveRecord::Base.connection.select_all("SELECT id, degree AS name FROM degrees WHERE degrees.organization_id = #{organization.id} AND degree LIKE '#{params[:q]}%' ORDER BY degree ASC LIMIT 20").to_json
    rescue
      render :json => []
    end
  end
end