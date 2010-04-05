class CreateTableCommunitiesUsers < ActiveRecord::Migration
  def self.up
    create_table :communities_users, :id => false do |t|
      t.integer :community_id
      t.integer :user_id
      t.datetime :since
    end
  end

  def self.down
    drop_table :communities_users
  end
end
