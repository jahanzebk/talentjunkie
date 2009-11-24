class CreateUserDetails < ActiveRecord::Migration
  def self.up
    create_table :user_details do |t|
      t.integer :user_id
      t.text :summary
      t.datetime :dob
    end
    
    connection.execute("INSERT INTO user_details (user_id) SELECT id FROM users")
    
    remove_column :users, :dob
  end

  def self.down
    add_column :users, :dob, :datetime
    drop_table :user_details
  end
end
