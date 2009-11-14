require 'csv'

class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :industries do |t|
      t.string :name
    end
    
    file = CSV::Reader.parse(File.open(RAILS_ROOT + "/db/industries.csv", 'rb'))
    file.each do |row|
      connection.execute("INSERT INTO industries (name) VALUES('#{row[0]}')")
    end
    
    
    create_table :organization_statuses do |t|
      t.string :name
    end
    
    connection.execute("INSERT INTO organization_statuses VALUES(1, 'Operating')")
    connection.execute("INSERT INTO organization_statuses VALUES(2, 'Out of Business')")
    connection.execute("INSERT INTO organization_statuses VALUES(3, 'Acquired')")

    create_table :organizations do |t|
      t.integer :industry_id
      t.integer :organization_status_id
      t.string :name
      t.string :description
      t.integer :year_founded
    end
    
    connection.execute("INSERT INTO organizations VALUES(1, 82, 1, 'GroupM', '', NULL)")
    connection.execute("INSERT INTO organizations VALUES(2, 67, 1, 'Google', '', NULL)")
  end

  def self.down
    drop_table :organizations
    drop_table :organization_statuses
    drop_table :industries
  end
end
