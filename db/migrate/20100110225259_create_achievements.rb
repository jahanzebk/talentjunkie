class CreateAchievements < ActiveRecord::Migration
  def self.up
    create_table :achievements do |t|
      t.string :title
      t.string :prize
    end
    
    create_table :achievement_steps do |t|
      t.integer :achievement_id
      t.string :title
    end
    
    create_table :achievement_steps_users, :id => false do |t|
      t.integer :achievement_step_id
      t.integer :user_id
    end
    
    connection.execute("INSERT INTO achievements VALUES (1, 'Level 1', 'Unlocks profile statistics')")
    connection.execute("INSERT INTO achievements VALUES (2, 'Level 2', 'Unlocks something else')")
    # connection.execute("INSERT INTO achievements VALUES (3, 'Level 3', '')")
    # connection.execute("INSERT INTO achievements VALUES (4, 'Level 4', '')")
    
    connection.execute("INSERT INTO achievement_steps VALUES (1, 1, 'Sign up')")
    connection.execute("INSERT INTO achievement_steps VALUES (2, 1, 'Add a position')")
    connection.execute("INSERT INTO achievement_steps VALUES (3, 1, 'Add a diploma or certification')")
    connection.execute("INSERT INTO achievement_steps VALUES (4, 1, 'Add a summary to your profile')")
    connection.execute("INSERT INTO achievement_steps VALUES (5, 1, 'Follow 5 people')")
    connection.execute("INSERT INTO achievement_steps VALUES (6, 1, 'Follow 3 organizations')")
    
    connection.execute("INSERT INTO achievement_steps VALUES (7, 2, 'Follow 50 people')")
    connection.execute("INSERT INTO achievement_steps VALUES (8, 2, 'Be followed by 20 people')")
    connection.execute("INSERT INTO achievement_steps VALUES (9, 2, 'Tweet your profile')")
  end

  def self.down
    drop_table :achievement_steps_users
    drop_table :achievement_steps
    drop_table :achievements
  end
end
