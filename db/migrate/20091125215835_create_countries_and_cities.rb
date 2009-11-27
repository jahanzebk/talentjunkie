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
    
    connection.execute("INSERT INTO countries VALUES(245, 'UK', 'United Kingdom')" )
    connection.execute("INSERT INTO countries VALUES(195, 'PO', 'Portugal')")
    
    connection.execute("INSERT INTO cities VALUES (2094941, 245, 'London')")
  end

  def self.down
    drop_table :cities
    drop_table :countries
  end
end
