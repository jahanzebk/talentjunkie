class CreateUserSettings < ActiveRecord::Migration
  def self.up
    create_table :user_settings do |t|
      t.integer :user_id
      t.integer :recruit_mode, :default => 0
    end
    
    User.all.each do |u|
      connection.execute("INSERT INTO user_settings (user_id) VALUES (#{u.id})")
    end
  end

  def self.down
    drop_table :user_settings
  end
end
