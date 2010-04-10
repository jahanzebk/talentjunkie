class UpdateAchievementSteps < ActiveRecord::Migration
  def self.up
    connection.execute("UPDATE achievement_steps SET achievement_id = 1 WHERE id in (1, 2, 4)")
    connection.execute("UPDATE achievement_steps SET achievement_id = 2 WHERE id in (3, 5, 6, 7, 8, 9)")
    
    connection.execute('UPDATE achievements SET description = "Your profile is currently locked and other users don\'t have access to it. To unlock your profile, add a summary and one position. This way, people won\'t need to see an empty profile!" WHERE id = 1')
  end

  def self.down
  end
end
