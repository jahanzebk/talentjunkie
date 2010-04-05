class CreateTableOpenings < ActiveRecord::Migration
  def self.up
    create_table :openings do |t|
      t.integer :state, :default => 0
      t.integer :city_id
      t.integer :position_id
      t.text :description
      t.text :benefits
      t.integer :contract_type_id, :default => 1
      t.integer :contract_periodicity_type_id, :default => 1
      t.integer :contract_rate_type_id, :default => 1
      t.string :rate
      t.datetime :from
      t.datetime :to
      t.integer :posted_by_user_id      
      t.timestamps
    end
    
    rename_column :job_applications, :contract_id, :opening_id
    rename_column :job_application_stages, :contract_id, :opening_id
  end

  def self.down
    rename_column :job_application_stages, :opening_id, :contract_id
    rename_column :job_applications, :opening_id, :contract_id
    drop_table :openings
  end
end
