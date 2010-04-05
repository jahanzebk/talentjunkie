class CreateCommunitiesOpenings < ActiveRecord::Migration
  def self.up
    create_table :communities_openings, :id => false do |t|
      t.integer :community_id
      t.integer :opening_id
      t.datetime :expires_on
    end
  end

  def self.down
    drop_table :communities_openings
  end
end
