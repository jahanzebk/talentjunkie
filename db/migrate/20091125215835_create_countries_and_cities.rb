require 'csv'

class CreateCountriesAndCities < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string :iso_code, :limit => 2
      t.string :name
    end
    
    create_table :cities do |t|
      t.integer :country_id
      t.string :name
    end
  
    countries =  CSV::Reader.parse(File.open(RAILS_ROOT + "/db/countries/GEODATASOURCE-COUNTRY.TXT", 'r')).collect {|c| [c[0].split("\t")[0].strip, c[0].split("\t")[3].strip] }
    countries.shift # lose header
    countries.each do |country_array|
      connection.execute("INSERT INTO countries (iso_code, name) VALUES(\"#{country_array[0]}\", \"#{country_array[1]}\")")
    end
    
    previous_iso_code = nil
    country_id = 0
    counter = 1
    
    puts "Processing cities..."
    
    default_level = ActiveRecord::Base.logger.level
    ActiveRecord::Base.logger.level = Logger::INFO
    
    ActiveRecord::Base.transaction do
      CSV::Reader.parse(File.open(RAILS_ROOT + "/db/countries/GEODATASOURCE-CITIES-FREE.TXT", 'r')).each do |row|
        
        iso_code = row[0].split("\t")[0].strip
        name = row[0].split("\t")[1].strip
        
        if previous_iso_code != iso_code
          puts iso_code
          previous_iso_code = iso_code
          country_id = connection.select_value("SELECT id FROM countries WHERE iso_code = '#{iso_code}' LIMIT 1")
        end
        
        connection.execute("INSERT INTO cities (country_id, name) VALUES(#{country_id}, \"#{name}\")") if country_id
        counter += 1
        puts "." if counter % 10000 == 0
      end
    end
    
    ActiveRecord::Base.logger.level = default_level
    
    connection.execute("create index country_id_index on cities(country_id)")
    connection.execute("create index city_initials_index on cities(name(3))")
  end
  

  def self.down
    # drop_table :cities
    # drop_table :countries
  end
end
