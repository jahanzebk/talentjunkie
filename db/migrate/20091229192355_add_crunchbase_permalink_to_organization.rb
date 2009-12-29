class AddCrunchbasePermalinkToOrganization < ActiveRecord::Migration
  def self.up
    add_column :organizations, :crunchbase_permalink, :string
  end

  def self.down
    remove_column :organizations, :crunchbase_permalink
  end
end
