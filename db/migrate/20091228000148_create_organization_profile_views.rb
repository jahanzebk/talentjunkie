class CreateOrganizationProfileViews < ActiveRecord::Migration
  def self.up
    create_table :organization_profile_views, :id => false do |t|
      t.integer :viewer_id
      t.integer :organization_id
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :organization_profile_views
  end
end
