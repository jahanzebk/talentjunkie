class CreateDegrees < ActiveRecord::Migration
  def self.up
    create_table :degrees do |t|
      t.integer :user_id
      t.integer :organization_id
      t.string :degree
      t.string :major
      t.timestamps
    end
    
    create_table :diplomas do |t|
      t.integer :degree_id
      t.integer :user_id
      t.integer :from_month
      t.integer :from_year
      t.integer :to_month
      t.integer :to_year
      t.timestamps
    end
  end

  def self.down
    drop_table :diplomas
    drop_table :degrees
  end
end
