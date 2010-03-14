class UpdateAchievementsData < ActiveRecord::Migration
  def self.up
    connection.execute("UPDATE achievements SET prize = 'Unlocks public profile' WHERE id = 1")
    connection.execute("DELETE FROM achievements WHERE id = 2")
    
    connection.execute("UPDATE achievement_steps SET `order` = 1 WHERE id = 1")
    connection.execute("UPDATE achievement_steps SET `order` = 2 WHERE id = 4")
    connection.execute("UPDATE achievement_steps SET `order` = 3 WHERE id = 2")
    connection.execute("UPDATE achievement_steps SET `order` = 4 WHERE id = 3")
  end

  def self.down
  end
end
