class CreateFollowingPeopleAndOrganizations < ActiveRecord::Migration
  def self.up
    create_table :following_people, :id => false do |t|
      t.integer :follower_user_id
      t.integer :followed_user_id
      t.timestamps
    end
    create_table :following_organizations, :id => false do |t|
      t.integer :user_id
      t.integer :organization_id
      t.timestamps
    end
  end

  def self.down
    drop_table :following_organizations
    drop_table :following_people
  end
end
