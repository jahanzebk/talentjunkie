class SearchRemoteController < ApplicationController
  def search
    begin
      results = []

      User.all(:conditions => ["CONCAT(first_name, ' ', last_name) LIKE ? ", "%#{params[:q]}%"], :order => "first_name ASC", :limit => 10).each do |person|
        results << SearchResult.new(person, person.full_name, person.title, person_path(person))
      end

      Organization.all(:conditions => ["name LIKE ? ", "%#{params[:q]}%"], :order => "name ASC", :limit => 10).each do |organization|
        industry = organization.industry ? organization.industry.name : ""
        results << SearchResult.new(organization, organization.name, industry, url_for(organization))
      end
      
      render :json =>  results.to_json
    rescue
      raise
      render :json => []
    end
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

  def to_json
    hash_for_json_attributes = {}
    instance_variables.each do |attribute_name|
      hash_for_json_attributes[attribute_name[1..-1]] = self.instance_variable_get(attribute_name)
    end
    hash_for_json_attributes.to_json
  end
end