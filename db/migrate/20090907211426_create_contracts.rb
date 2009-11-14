class CreateContracts < ActiveRecord::Migration
  def self.up
    create_table :contract_types do |t|
      t.string :name
    end
    
    connection.execute("INSERT INTO contract_types VALUES (1, 'Permanent')")
    connection.execute("INSERT INTO contract_types VALUES (2, 'Contract')")
    
    create_table :contract_periodicity_types do |t|
      t.string :name
    end
    
    connection.execute("INSERT INTO contract_periodicity_types VALUES (1, 'Full Time')")
    connection.execute("INSERT INTO contract_periodicity_types VALUES (2, 'Part Time')")
    
    create_table :contract_rate_types do |t|
      t.string :name
    end
    
    connection.execute("INSERT INTO contract_rate_types VALUES (1, 'Salary')")
    connection.execute("INSERT INTO contract_rate_types VALUES (2, 'Hourly rate')")
    connection.execute("INSERT INTO contract_rate_types VALUES (3, 'Daily rate')")
    connection.execute("INSERT INTO contract_rate_types VALUES (4, 'Fixed price')")
    
    create_table :contracts do |t|
      t.integer :contract_type_id
      t.integer :contract_periodicity_type_id
      t.integer :contract_rate_type_id
      t.integer :rate
      t.integer :position_id
      t.string :description
      t.string :benefits
      t.integer :user_id
      t.integer :from_month
      t.integer :from_year
      t.integer :to_month
      t.integer :to_year
      t.integer :posted_by_user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :contracts
  end
end
