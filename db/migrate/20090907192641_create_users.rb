class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :user_emails do |t|
      t.integer :user_id
      t.string :email
      t.integer :primary
    end
      
    create_table :users do |t|
      t.string :primary_email
      t.string :password_hash
      t.string :password_salt
      t.string :first_name
      t.string :last_name
      t.datetime :dob
      t.string :persistence_token
      t.timestamps
    end

    (1..100).each do |i|
      ActiveRecord::Base.connection.execute("INSERT INTO user_emails VALUES(#{i}, #{i}, 'user_#{i}@test.com', 1)")    
      ActiveRecord::Base.connection.execute("INSERT INTO users  VALUES(#{i}, 'user_#{i}@test.com', '47b11f294bb90aeba27df8033b53baea5bf6d6fabd503b079d78aec14c57c34402c16f253626ac375084f941bd196f1c178ab8236b227631ac9f2980f56ed8b8', 'pEhebh2rUK3h5bw0NlCv', 'user', '#{i}', '1976-09-29', '1b391763d28ac0323764643cfe9940ff7596aafb27abb95a928c6fc881f0854227b45bb810a7d2c2b91532d653f29833a5489e19324515a957abb75b196ae28b', NOW(), NOW())")  
    end
    
  end
  
  def self.down
    drop_table :users
  end
end
