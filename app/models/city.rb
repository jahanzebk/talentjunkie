class City < ActiveRecord::Base
  belongs_to :country
  
  def city_and_country_name
    "#{name}, #{country.name}"
  end
end