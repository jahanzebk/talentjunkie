class CreateTableCommunitiesOrganizations < ActiveRecord::Migration
  def self.up
    create_table :communities_organizations, :id => false do |t|
      t.integer :community_id
      t.integer :organization_id
      t.datetime :since
    end
  end

  def self.down
    drop_table :communities_organizations
  end
end
